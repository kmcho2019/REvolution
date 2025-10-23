module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Two's complement subtraction: A - B = A + ~B + 1
    wire [63:0] B_comp = ~B;
    wire [63:0] carry;

    // Hierarchical 4-bit blocks with optimized carry computation
    genvar i;
    generate
        for (i=0; i<64; i=i+4) begin : SUB_BLOCKS
            // First block gets carry-in = 1 for subtraction
            if (i == 0) begin
                assign carry[0] = (A[0] & B_comp[0]) | ((A[0] ^ B_comp[0]) & 1'b1);
                assign result[0] = A[0] ^ B_comp[0] ^ 1'b1;
                
                assign carry[1] = (A[1] & B_comp[1]) | ((A[1] ^ B_comp[1]) & carry[0]);
                assign result[1] = A[1] ^ B_comp[1] ^ carry[0];
                
                assign carry[2] = (A[2] & B_comp[2]) | ((A[2] ^ B_comp[2]) & carry[1]);
                assign result[2] = A[2] ^ B_comp[2] ^ carry[1];
                
                assign carry[3] = (A[3] & B_comp[3]) | ((A[3] ^ B_comp[3]) & carry[2]);
                assign result[3] = A[3] ^ B_comp[3] ^ carry[2];
            end
            else begin
                assign carry[i]   = (A[i]   & B_comp[i])   | ((A[i]   ^ B_comp[i])   & carry[i-1]);
                assign result[i]   = A[i]   ^ B_comp[i]   ^ carry[i-1];
                
                assign carry[i+1] = (A[i+1] & B_comp[i+1]) | ((A[i+1] ^ B_comp[i+1]) & carry[i]);
                assign result[i+1] = A[i+1] ^ B_comp[i+1] ^ carry[i];
                
                assign carry[i+2] = (A[i+2] & B_comp[i+2]) | ((A[i+2] ^ B_comp[i+2]) & carry[i+1]);
                assign result[i+2] = A[i+2] ^ B_comp[i+2] ^ carry[i+1];
                
                assign carry[i+3] = (A[i+3] & B_comp[i+3]) | ((A[i+3] ^ B_comp[i+3]) & carry[i+2]);
                assign result[i+3] = A[i+3] ^ B_comp[i+3] ^ carry[i+2];
            end
        end
    endgenerate

    // Efficient overflow detection
    assign overflow = (A[63] ^ B[63]) && (A[63] ^ result[63]);

endmodule