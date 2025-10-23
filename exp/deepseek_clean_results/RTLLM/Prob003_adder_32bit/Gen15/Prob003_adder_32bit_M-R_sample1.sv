module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [32:0] carry;
    wire [31:0] G, P;
    genvar i;
    
    assign carry[0] = 1'b0;
    
    // Generate propagate and generate terms
    assign P = A ^ B;
    assign G = A & B;
    
    // Generate carry terms for each bit
    generate
        for (i = 1; i <= 32; i = i + 1) begin : carry_gen
            assign carry[i] = G[i-1] | (P[i-1] & carry[i-1]);
        end
    endgenerate
    
    // Generate sum terms
    assign S = P ^ carry[31:0];
    assign C32 = carry[32];
endmodule