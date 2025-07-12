module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    wire [64:0] diff;
    assign diff[0] = 1'b1; // +1 for two's complement subtraction
    
    genvar i;
    generate
        for (i=0; i<64; i=i+1) begin : SUB_BITS
            assign diff[i+1] = (A[i] ^ ~B[i] ^ diff[i]) ? 
                              (A[i] & ~B[i]) | ((A[i] ^ ~B[i]) & diff[i]) : 
                              1'b0;
            assign result[i] = A[i] ^ ~B[i] ^ diff[i];
        end
    endgenerate

    // Overflow detection remains identical
    assign overflow = (A[63] ^ B[63]) && (A[63] ^ result[63]);

endmodule