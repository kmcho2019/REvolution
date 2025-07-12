module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire all_zero = ~a & ~b & ~c & ~d;
    wire xor_all = a ^ b ^ c ^ d;
    
    assign q = all_zero | ~xor_all;

endmodule