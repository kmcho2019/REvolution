module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire xor_result;
    wire all_zero;
    
    assign xor_result = a ^ b ^ c ^ d;
    assign all_zero = ~a & ~b & ~c & ~d;
    
    assign q = xor_result | all_zero;

endmodule