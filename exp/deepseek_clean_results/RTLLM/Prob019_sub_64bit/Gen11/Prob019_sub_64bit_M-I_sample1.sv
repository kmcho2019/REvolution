module sub_64bit (
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

    // Carry-lookahead subtractor implementation
    wire [63:0] B_comp = ~B;
    wire [15:0] group_prop;
    wire [15:0] group_gen;
    wire [16:0] carry;

    assign carry[0] = 1'b1; // Initialize carry for subtraction (2's complement)

    // Generate 4-bit carry-lookahead blocks
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : cla_blocks
            wire [3:0] P, G;
            wire [3:0] local_carry;
            
            // Calculate propagate and generate for each bit
            assign P[0] = A[i*4] ^ B_comp[i*4];
            assign G[0] = A[i*4] & B_comp[i*4];
            assign result[i*4] = P[0] ^ carry[i];
            assign local_carry[1] = G[0] | (P[0] & carry[i]);
            
            assign P[1] = A[i*4+1] ^ B_comp[i*4+1];
            assign G[1] = A[i*4+1] & B_comp[i*4+1];
            assign result[i*4+1] = P[1] ^ local_carry[1];
            assign local_carry[2] = G[1] | (P[1] & local_carry[1]);
            
            assign P[2] = A[i*4+2] ^ B_comp[i*4+2];
            assign G[2] = A[i*4+2] & B_comp[i*4+2];
            assign result[i*4+2] = P[2] ^ local_carry[2];
            assign local_carry[3] = G[2] | (P[2] & local_carry[2]);
            
            assign P[3] = A[i*4+3] ^ B_comp[i*4+3];
            assign G[3] = A[i*4+3] & B_comp[i*4+3];
            assign result[i*4+3] = P[3] ^ local_carry[3];
            
            // Group propagate and generate
            assign group_prop[i] = &P;
            assign group_gen[i] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
            
            // Calculate carry for next group
            if (i < 15) begin
                assign carry[i+1] = group_gen[i] | (group_prop[i] & carry[i]);
            end
        end
    endgenerate

    // Overflow detection (optimized using carry signals)
    assign overflow = (A[63] == B_comp[63]) && (result[63] != A[63]);

endmodule