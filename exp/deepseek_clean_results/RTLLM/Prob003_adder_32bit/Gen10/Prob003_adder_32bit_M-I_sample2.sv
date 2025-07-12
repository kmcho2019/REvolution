module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout,
    output G,
    output P
);
    wire [3:0] G_bit = A & B;
    wire [3:0] P_bit = A ^ B;
    wire [3:0] C;
    
    assign C[0] = Cin;
    assign C[1] = G_bit[0] | (P_bit[0] & C[0]);
    assign C[2] = G_bit[1] | (P_bit[1] & C[1]);
    assign C[3] = G_bit[2] | (P_bit[2] & C[2]);
    assign Cout = G_bit[3] | (P_bit[3] & C[3]);
    
    assign S = P_bit ^ C;
    assign G = G_bit[3] | (P_bit[3] & G_bit[2]) | (P_bit[3] & P_bit[2] & G_bit[1]) | 
               (P_bit[3] & P_bit[2] & P_bit[1] & G_bit[0]);
    assign P = P_bit[3] & P_bit[2] & P_bit[1] & P_bit[0];
endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout,
    output G,
    output P
);
    wire [3:0] G_block, P_block;
    wire [3:0] carry;
    
    // First level: 4-bit CLAs with generate/propagate outputs
    cla_4bit cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .S(S[3:0]), 
                  .Cout(carry[0]), .G(G_block[0]), .P(P_block[0]));
    cla_4bit cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(carry[0]), .S(S[7:4]), 
                  .Cout(carry[1]), .G(G_block[1]), .P(P_block[1]));
    cla_4bit cla2 (.A(A[11:8]), .B(B[11:8]), .Cin(carry[1]), .S(S[11:8]), 
                  .Cout(carry[2]), .G(G_block[2]), .P(P_block[2]));
    cla_4bit cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(carry[2]), .S(S[15:12]), 
                  .Cout(carry[3]), .G(G_block[3]), .P(P_block[3]));
    
    // Hierarchical lookahead for 16-bit carry
    assign G = G_block[3] | (P_block[3] & G_block[2]) | 
               (P_block[3] & P_block[2] & G_block[1]) | 
               (P_block[3] & P_block[2] & P_block[1] & G_block[0]);
    assign P = P_block[3] & P_block[2] & P_block[1] & P_block[0];
    assign Cout = G | (P & Cin);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire G_low, P_low;
    wire G_high, P_high;
    wire C16;
    
    // Lower 16 bits with generate/propagate outputs
    cla_16bit low (
        .A(A[16:1]), 
        .B(B[16:1]), 
        .Cin(1'b0), 
        .S(S[16:1]), 
        .Cout(C16),
        .G(G_low),
        .P(P_low)
    );
    
    // Upper 16 bits with generate/propagate outputs
    cla_16bit high (
        .A(A[32:17]), 
        .B(B[32:17]), 
        .Cin(C16), 
        .S(S[32:17]), 
        .Cout(C32),
        .G(G_high),
        .P(P_high)
    );
    
    // Second-level lookahead for faster carry propagation
    assign C16 = G_low | (P_low & 1'b0);  // Explicit calculation for clarity
    assign C32 = G_high | (P_high & C16);  // This is already handled in cla_16bit
endmodule