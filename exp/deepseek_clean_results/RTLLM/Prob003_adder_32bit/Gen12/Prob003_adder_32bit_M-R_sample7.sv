module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    wire [7:0] G = A & B;
    wire [7:0] P = A ^ B;
    wire [7:0] C;
    
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G[5] | (P[5] & C[5]);
    assign C[7] = G[6] | (P[6] & C[6]);
    assign Cout = G[7] | (P[7] & C[7]);
    
    assign S = P ^ C;
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] carry;
    
    // Generate 4x 8-bit CLA blocks
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : cla_block
            localparam start = i*8 + 1;
            localparam end = (i+1)*8;
            
            cla_8bit cla (
                .A(A[end:start]),
                .B(B[end:start]),
                .Cin(i == 0 ? 1'b0 : carry[i-1]),
                .S(S[end:start]),
                .Cout(carry[i])
            );
        end
    endgenerate
    
    assign C32 = carry[3];
endmodule