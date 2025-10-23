module sub_64bit (
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);
    // Treat inputs as unsigned for subtraction
    wire [64:0] full_result = {1'b0, A} - {1'b0, B};
    
    assign result = full_result[63:0];
    
    // Overflow occurs when:
    // MSB carry differs from expected sign (A[63] ^ B[63])
    assign overflow = (A[63] ^ B[63]) & (result[63] ^ A[63]);
    
endmodule