open Printf

(* GF(2^8) mul *)
let cMulGF2_8 x y =
    let ret = ref 0 in
    let ref_x = ref x in
    let ref_y = ref y in
    (
        for cnt=0 to 7 do
            if (!ref_y land 0x01) > 0 then ret := !ret lxor !ref_x;
            ref_x := !ref_x lsl 1;
            if ((!ref_x land 0x100) > 0) then ref_x := !ref_x lxor 0x11b;
            ref_y := !ref_y lsr 1
        done;
        !ret
    )
;;

(* read a hex data from specified file *)
let cInputSvar fname =
    ()
;;

(* write a hex data to specified file *)
let cOutputSvar v fname =
    ()
;;

(* print a hex data string of a svar *)
let cPrintSvar v vname =
    printf "%s:\n" vname;
    printf "\t%X\n" v
;;

(* print a hex data string of a mvar *)
let cPrintMvar v vname =
    let x = Array.length v in
    let y = Array.length v.(0) in
    printf "%s(%d:%d):\n" vname x y;
    for i=0 to (x-1) do
        printf "\t";
        for j=0 to (y-1) do
            printf "%X " v.(i).(j)
        done;
        printf "\n"
    done
;;

(* read a list of hex data from specified file *)
let cInputMvar fname =
    ()
;;

(* write a list of hex data to specified file *)
let cOutputMvar v fname =
    ()
;;

(* make a matrix from a one dimension array *)
let cMatrixMake dim v =
    let (x, y, z) = dim in
    let ret = Array.make_matrix x y 0 in
    let len = Array.length v in
    if (len >= x*y) then begin
        for i=0 to x-1 do
            for j=0 to y-1 do
                ret.(i).(j) <- v.(i*y+j)
            done
        done
    end else begin
        for i=0 to (len-1) do
            ret.(i / x).(i mod y) <- v.(i)
        done
    end;
    ret
;;

(* get single item from a matrix *)
let cMatrixSingle m cor =
    let (x, y, z_msb, z_lsb) = cor in
    m.(x).(y)
;;

(* get a block-matrix from a matrix *)
let cMatrixBlock m range =
    let (x_msb, x_lsb, y_msb, y_lsb, z_msb, z_lsb) = range in
    let x = (abs (x_msb-x_lsb))+1 in
    let y = (abs (y_msb-y_lsb))+1 in
    let ret = Array.make_matrix x y 0 in
    (* printf "x_msb:%d x_lsb:%d x:%d y_msb:%d y_lsb:%d y:%d\n" x_msb x_lsb x y_msb y_lsb y; *)
    for i=0 to x-1 do
        for j=0 to y-1 do
            if (x_msb > x_lsb) then begin
                if (y_msb > y_lsb) then begin
                    ret.(i).(j) <- m.(x_msb-i).(y_msb-j)
                end else begin
                    ret.(i).(j) <- m.(x_msb-i).(y_msb+j)
                end
            end else begin
                (* printf "i=%d j=%d x_msb:%d y_msb:%d\n" i j x_msb y_msb; *)
                if (y_msb > y_lsb) then begin
                    ret.(i).(j) <- m.(x_msb+i).(y_msb-j)
                end else begin
                    ret.(i).(j) <- m.(x_msb+i).(y_msb+j)
                end
            end
        done
    done;
    ret
;;

(* convert a matrix to an array *)
let cMatrix2List m =
    let empty = [||] in
    Array.fold_left Array.append m empty
;;

(* get a block-matrix from a matrix and convert it to an array *)
let cMatrixList m range = cMatrix2List (cMatrixBlock m range)
;;

(* bit not a matrix *)
let cMatrixNot m =
    let (m_x,m_y) = (Array.length m, Array.length m.(0)) in
    let ret = Array.make_matrix m_y m_x 0 in
    for i=0 downto m_y-1 do
        for j=0 downto m_x-1 do
            ret.(i).(j) <- -m.(j).(i)
        done
    done;
    ret
;;

(* transform a matrix *)
let cMatrixTran m =
    let (m_x,m_y) = (Array.length m, Array.length m.(0)) in
    let ret = Array.make_matrix m_y m_x 0 in
    for i=0 downto m_y-1 do
        for j=0 downto m_x-1 do
            ret.(i).(j) <- m.(j).(i)
        done
    done;
    ret
;;

(* print a sub-matrix *)
let cMatrixPrintSub m range =
    let (x_msb, x_lsb, y_msb, y_lsb, z_msb, z_lsb) = range in
    if x_msb > x_lsb then begin
        for i=x_msb downto x_lsb do
            if (y_msb > y_lsb) then begin
                for j=y_msb downto y_lsb do
                    printf "%.8x " m.(i).(j)
                done
            end else begin
                for j=y_lsb to y_msb do
                    printf "%.8x " m.(i).(j)
                done
            end;
            printf "\n"
        done
    end else begin
        for i=x_msb to x_lsb do
            if (y_msb > y_lsb) then begin
                for j=y_msb downto y_lsb do
                    printf "%.8x " m.(i).(j)
                done
            end else begin
                for j=y_msb to y_lsb do
                    printf "%.8x " m.(i).(j)
                done
            end;
            printf "\n"
        done
    end;
    ()
;;

(* print a sub-matrix *)
let cMatrixDump m name =
    printf "%s=\n" name;
    let (x, y) = (Array.length m, Array.length m.(0)) in
    for i=0 to x-1 do
        printf "\t";
        for j=0 to y-1 do
            printf "%2x " m.(i).(j)
        done;
        printf "\n"
    done;
    ()
;;

(* matrix arithmetic map *)
let cMatrixArithMap a b f =
    let (a_x,a_y) = ((Array.length a), (Array.length a.(0))) in
    let (b_x,b_y) = ((Array.length b), (Array.length b.(0))) in
    let ret = Array.make_matrix a_x a_y 0 in
    if ((a_x != b_x) || (a_y != b_y)) then begin
        printf "ERROR: cMatrixArithMap (%d,%d) != (%d,%d)\n" a_x a_y b_x b_y
    end else begin
        for i=0 to (a_x-1) do
            for j=0 to (a_y-1) do
                ret.(i).(j) <- f a.(i).(j) b.(i).(j)
            done
        done
    end;
    ret
;;

(* matrix arithmetic add *)
let cMatrixAdd a b = cMatrixArithMap a b (+)
;;

(* matrix arithmetic sub *)
let cMatrixSub a b = cMatrixArithMap a b (-)
;;

(* matrix arithmetic mul *)
let cMatrixMul a b = cMatrixArithMap a b ( * )
;;

(* matrix arithmetic div *)
let cMatrixDiv a b = cMatrixArithMap a b ( / )
;;

(* matrix arithmetic mod *)
let cMatrixMod a b = cMatrixArithMap a b ( mod )
;;

(* matrix arithmetic add_gf *)
let cMatrixAddGF a b = cMatrixArithMap a b (lxor)
;;

(* matrix arithmetic BXOR *)
let cMatrixBxor a b = cMatrixArithMap a b (lxor)
;;

(* matrix arithmetic BAND *)
let cMatrixBand a b = cMatrixArithMap a b (land)
;;

(* matrix arithmetic BOR *)
let cMatrixBor a b = cMatrixArithMap a b (lor)
;;

(* matrix arithmetic sub_gf *)
let cMatrixSubGF a b = cMatrixArithMap a b (lxor)
;;

(* matrix algebraic mul *)
let cMatrixAlgebMul a b =
    let (a_x,a_y) = ((Array.length a), (Array.length a.(0))) in
    let (b_x,b_y) = ((Array.length b), (Array.length b.(0))) in
    let ret = Array.make_matrix a_x b_y 0 in
    if (a_y != b_x) then begin
        printf "ERROR: cMatrixAlgebMul (%d,%d) (%d,%d) while %d != %d \n" a_x a_y b_x b_y a_y b_x
    end else begin
        for i=0 to (a_x-1) do
            for j=0 to (b_y-1) do
                let res = ref 0 in
                for k=0 to (a_y -1) do
                    res := !res + a.(i).(k) * b.(k).(j)
                done;
                ret.(i).(j) <- !res
            done
        done
    end;
    ret
;;

(* matrix algebraic mulGF *)
let cMatrixAlgebMulGFx a b gf =
    let (a_x,a_y) = ((Array.length a), (Array.length a.(0))) in
    let (b_x,b_y) = ((Array.length b), (Array.length b.(0))) in
    let ret = Array.make_matrix a_x b_y 0 in
    if (a_y != b_x) then begin
        printf "ERROR: cMatrixAlgebMul (%d,%d) (%d,%d) while %d != %d \n" a_x a_y b_x b_y a_y b_x
    end else begin
        for i=0 to (a_x-1) do
            for j=0 to (b_y-1) do
                let res = ref 0 in
                for k=0 to (a_y-1) do
                    res := !res lxor (gf a.(i).(k) b.(k).(j))
                done;
                ret.(i).(j) <- !res
            done
        done
    end;
    ret
;;

let cMatrixAlgebMulGF8 a b = cMatrixAlgebMulGFx a b cMulGF2_8
;;

(* matrix pbox *)
let cMatrixPboxAes a b =
    let (a_x,a_y) = ((Array.length a), (Array.length a.(0))) in
    let (b_x,b_y) = ((Array.length b), (Array.length b.(0))) in
    let ret = Array.make_matrix a_x a_y 0 in
    if ((a_x != b_x) || (a_y != b_y)) then begin
        printf "ERROR: cMatrixPbox (%d,%d) != (%d,%d)\n" a_x a_y b_x b_y
    end else begin
        for i=0 to (a_x-1) do
            for j=0 to (a_y-1) do
                let idx_x = b.(i).(j) / a_y in
                let idx_y = b.(i).(j) mod a_y in
                ret.(i).(j) <- a.(idx_x).(idx_y)
            done
        done
    end;
    ret
;;

let cMatrixPbox a b =
    let (a_x,a_y) = ((Array.length a), (Array.length a.(0))) in
    let (b_x,b_y) = ((Array.length b), (Array.length b.(0))) in
    let ret = Array.make_matrix b_x b_y 0 in
    for i=0 to (b_x-1) do
        for j=0 to (b_y-1) do
            let idx_x = b.(i).(j)  /  a_y in
            let idx_y = b.(i).(j) mod a_y in
            (* printf "a_y=%d idx_x=%d idx_y=%d\n" a_y idx_x idx_y; *)
            ret.(i).(j) <- a.(idx_x).(idx_y)
        done
    done;
    ret
;;

(* matrix sbox *)
let cMatrixSbox a b =
    let (a_x,a_y) = ((Array.length a), (Array.length a.(0))) in
    let (b_x,b_y) = ((Array.length b), (Array.length b.(0))) in
    let ret = Array.make_matrix a_x a_y 0 in
    for i=0 to (a_x-1) do
        for j=0 to (a_y-1) do
            let idx_x = a.(i).(j)  /  b_y in
            let idx_y = a.(i).(j) mod b_y in
            if (idx_x >= b_x) || (idx_y >= b_y) then
                printf "ERROR: data 0x%x out of Sbox(0x%x,0x%x)\n" a.(i).(j) b_x b_y
            else
                ret.(i).(j) <- b.(idx_x).(idx_y)
        done
    done;
    ret
;;

let cMatrixSboxAes a b =
    let (a_x,a_y) = ((Array.length a), (Array.length a.(0))) in
    let (b_x,b_y) = ((Array.length b), (Array.length b.(0))) in
    let ret = Array.make_matrix a_x a_y 0 in
    for i=0 to (a_x-1) do
        for j=0 to (a_y-1) do
            let idx_x = (a.(i).(j) lsr 4) land 0x0f in
            let idx_y = a.(i).(j) land 0x0f in
            (* printf "INFO: data 0x%x Sbox(0x%x,0x%x) idx_x:%d idx_y:%d\n" a.(i).(j) b_x b_y idx_x idx_y; *)
            if (idx_x >= b_x) || (idx_y >= b_y) then
                printf "ERROR: data 0x%x out of Sbox(0x%x,0x%x)\n" a.(i).(j) b_x b_y
            else
                ret.(i).(j) <- b.(idx_x).(idx_y)
        done
    done;
    ret
;;

(* operator override *)
(* scalar GF mul *)
let ( *^ ) x y = cMulGF2_8 x y
;;
let ( *^< ) x y = cMulGF2_8 x y
;;

(* matrix band *)
let ( &@ ) x y = cMatrixBand x y
;;

(* matrix bor *)
let ( |@ ) x y = cMatrixBor x y
;;

(* matrix bxor *)
let ( ^@ ) x y = cMatrixBxor x y
;;

(* matrix add *)
let ( +@ ) x y = cMatrixAdd x y
;;

(* matrix sub *)
let ( -@ ) x y = cMatrixSub x y
;;

(* matrix mul *)
let ( *- ) x y = ()
;; (* TODO... *)
let ( *| ) x y = cMatrixMul x y
;;

(* matrix algebraic mul *)
let ( *@ ) x y = cMatrixAlgebMul x y
;;

(* matrix algebraic gf mul *)
let ( *|^ ) x y = cMatrixAlgebMulGF8 x y
;; (* TODO... *)
let ( *|^< ) x y = cMatrixAlgebMulGF8 x y
;; (* TODO... *)
let ( *@^ ) x y = cMatrixAlgebMulGF8 x y
;;
let ( *@^< ) x y = cMatrixAlgebMulGF8 x y
;;

(* matrix not *)
let ( %@~ ) x = cMatrixNot x
;;

(* matrix transformation *)
let ( %@-| ) x = cMatrixTran x
;;

(* matrix vertical concat *)
let ( %@| ) x y =
    let x_h = Array.length x in
    let x_w = Array.length x.(0) in
    let y_h = Array.length y in
    let y_w = Array.length y.(0) in
    let ret = Array.make_matrix (x_h) (x_w+y_w) 0 in
    if (x_h != y_h) then begin
        printf "ERROR: matrix vertical concat x_h(0x%x) != y_h(0x%x)\n" x_h y_h
    end else begin
        for i=0 to x_h-1 do
            for j=0 to x_w-1 do
                ret.(i).(j) <- x.(i).(j)
            done
        done;
        for i= 0 to x_h-1 do
            for j=0 to y_w-1 do
                ret.(i).(j+x_w) <- y.(i).(j)
            done
        done
    end;
    ret
;;

(* matrix horizontal concat *)
let ( %@- ) x y =
    let x_h = Array.length x in
    let x_w = Array.length x.(0) in
    let y_h = Array.length y in
    let y_w = Array.length y.(0) in
    let ret = Array.make_matrix (x_h+y_h) (x_w+y_w) 0 in
    if (x_w != y_w) then begin
        printf "ERROR: matrix horizontal concat x_w(0x%x) != y_w(0x%x)\n" x_w y_w 
    end else begin
        for i=0 to x_h-1 do
            for j=0 to x_w-1 do
                ret.(i).(j) <- x.(i).(j)
            done
        done;
        for i=0 to y_h-1 do
            for j=0 to y_w-1 do
                ret.(i+x_h).(j) <- y.(i).(j)
            done
        done
    end;
    ret
;;

(* permutation *)
let ( %@> ) x y = cMatrixPbox x y
;;

(* substitution *)
let ( %@< ) x y = cMatrixSbox x y
;;


(* map *)
let ( %@|> ) ar f =
    let x_h = Array.length ar in
    let x_w = Array.length ar.(0) in
    let ret = Array.make_matrix x_h x_w 0 in
    for i=0 to (x_h-1) do
        for j=0 to (x_w-1) do
            ret.(i).(j) <- f ar.(i).(j)
        done
    done;
    ret
;;

(* fold *)
let ( %@|< ) ar f =
    let x_h = Array.length ar in
    let x_w = Array.length ar.(0) in
    let ret = ref 0 in
    for i=0 to (x_h-1) do
        for j=0 to (x_w-1) do
            ret := f !ret ar.(i).(j)
        done
    done;
    ret
;;

(* Matrix dimensions *)
let cX v = Array.length v;;
let cY v = Array.length v.(0);;
let cZ v = 31; (* FIMXE: currently only support 31bit integer *)

