module cla_4bit #(
    parameter WIDTH = 4
) (
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    input Cin,
    output [WIDTH-1:0] S,
    output Cout,
    output Gout,
    output Pout
);
    wire [WIDTH-1:0] G = A & B;
    wire [WIDTH-1:0] P = A ^ B;
    
    wire [WIDTH:0] C;
    assign C[0] = Cin;
    
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate
    
    assign S = P ^ C[WIDTH-1:0];
    assign Cout = C[WIDTH];
    assign Gout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign Pout = &P;
endmodule

module cla_16bit #(
    parameter WIDTH = 16
) (
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    input Cin,
    output [WIDTH-1:0] S,
    output Cout
);
    wire [3:0] G, P;
    wire [3:0] carry;
    
    cla_4bit cla0 (A[3:0], B[3:0], Cin, S[3:0], carry[0], G[0], P[0]);
    cla_4bit cla1 (A[7:4], B[7:4], carry[0], S[7:4], carry[1], G[1], P[1]);
    cla_4bit cla2 (A[11:8], B[11:8], carry[1], S[11:8], carry[2], G[2], P[2]);
    cla_4bit cla3 (A[15:12], B[15:12], carry[2], S[15:12], carry[3], G[3], P[3]);
    
    // Block-level carry lookahead
    wire [3:1] block_carry;
    assign block_carry[1] = G[0] | (P[0] & Cin);
    assign block_carry[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign block_carry[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    assign Cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | 
                 (P[3] & P[2] & P[1] & P[0] & Cin);
endmodule

module adder_32bit #(
    parameter WIDTH = 32
) (
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    output [WIDTH-1:0] S,
    output Cout
);
    wire G0, P0, G1, P1;
    wire mid_carry;
    
    cla_16bit low (
        .A(A[15:0]),
        .B(B[15:0]),
        .Cin(1'b0),
        .S(S[15:0]),
        .Cout()
    );
    
    cla_16bit high (
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(low.Cout),
        .S(S[31:16]),
        .Cout(Cout)
    );
    
    // Second-level lookahead
    assign mid_carry = G0 | (P0 & 1'b0);
    assign Cout = G1 | (P1 & G0) | (P1 & P0 & 1'b0);
endmodule