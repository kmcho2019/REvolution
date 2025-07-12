module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output G,
    output P
);
    wire [3:0] G_bits = A & B;
    wire [3:0] P_bits = A ^ B;
    wire [3:0] C;
    
    assign C[0] = Cin;
    assign C[1] = G_bits[0] | (P_bits[0] & C[0]);
    assign C[2] = G_bits[1] | (P_bits[1] & C[1]);
    assign C[3] = G_bits[2] | (P_bits[2] & C[2]);
    
    assign G = G_bits[3] | (P_bits[3] & G_bits[2]) | 
              (P_bits[3] & P_bits[2] & G_bits[1]) | 
              (P_bits[3] & P_bits[2] & P_bits[1] & G_bits[0]);
    assign P = P_bits[3] & P_bits[2] & P_bits[1] & P_bits[0];
    assign S = P_bits ^ C;
endmodule

module carry_select_unit (
    input [3:0] A,
    input [3:0] B,
    output [3:0] S0,
    output [3:0] S1,
    output G,
    output P
);
    cla_4bit cla0 (.A(A), .B(B), .Cin(1'b0), .S(S0), .G(G), .P(P));
    cla_4bit cla1 (.A(A), .B(B), .Cin(1'b1), .S(S1));
endmodule

module carry_lookahead_tree (
    input [7:0] G,
    input [7:0] P,
    input Cin,
    output [7:0] C
);
    // First level
    wire [3:0] G1, P1;
    assign G1[0] = G[0] | (P[0] & Cin);
    assign P1[0] = P[0];
    assign G1[1] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign P1[1] = P[1] & P[0];
    assign G1[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    assign P1[2] = P[2] & P[1] & P[0];
    assign G1[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | 
                  (P[3] & P[2] & P[1] & P[0] & Cin);
    assign P1[3] = P[3] & P[2] & P[1] & P[0];
    
    // Second level
    assign C[0] = G1[0] | (P1[0] & Cin);
    assign C[1] = G1[1] | (P1[1] & Cin);
    assign C[2] = G1[2] | (P1[2] & Cin);
    assign C[3] = G1[3] | (P1[3] & Cin);
    assign C[4] = G[4] | (P[4] & C[3]);
    assign C[5] = G[5] | (P[5] & C[4]);
    assign C[6] = G[6] | (P[6] & C[5]);
    assign C[7] = G[7] | (P[7] & C[6]);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [7:0] segment_G, segment_P;
    wire [7:0] segment_carry;
    wire [7:0][3:0] S0, S1;
    
    // Generate all carry-select segments
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : segments
            carry_select_unit csu (
                .A(A[(i*4)+4 : (i*4)+1]),
                .B(B[(i*4)+4 : (i*4)+1]),
                .S0(S0[i]),
                .S1(S1[i]),
                .G(segment_G[i]),
                .P(segment_P[i])
            );
        end
    endgenerate
    
    // Carry lookahead tree
    carry_lookahead_tree clt (
        .G(segment_G),
        .P(segment_P),
        .Cin(1'b0),
        .C(segment_carry)
    );
    
    // Mux correct sums based on actual carries
    assign S[4:1]   = segment_carry[0] ? S1[0] : S0[0];
    assign S[8:5]   = segment_carry[1] ? S1[1] : S0[1];
    assign S[12:9]  = segment_carry[2] ? S1[2] : S0[2];
    assign S[16:13] = segment_carry[3] ? S1[3] : S0[3];
    assign S[20:17] = segment_carry[4] ? S1[4] : S0[4];
    assign S[24:21] = segment_carry[5] ? S1[5] : S0[5];
    assign S[28:25] = segment_carry[6] ? S1[6] : S0[6];
    assign S[32:29] = segment_carry[7] ? S1[7] : S0[7];
    
    assign C32 = segment_carry[7];
endmodule