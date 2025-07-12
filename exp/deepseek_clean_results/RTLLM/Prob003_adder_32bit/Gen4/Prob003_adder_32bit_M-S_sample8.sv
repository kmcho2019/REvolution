module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [32:0] G = {A & B, 1'b0};
    wire [32:0] P = {A ^ B, 1'b0};
    wire [32:0] C;
    
    assign C[0] = 1'b0;
    
    genvar i;
    generate
        for (i = 1; i <= 32; i = i + 1) begin : carry_chain
            assign C[i] = G[i-1] | (P[i-1] & C[i-1]);
        end
    endgenerate
    
    assign S = P[32:1] ^ C[32:1];
    assign C32 = C[32];
endmodule