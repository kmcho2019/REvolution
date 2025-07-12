// 4-bit carry-lookahead adder
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    input Cin,
    output [4:1] S,
    output Cout
);

wire [4:1] G;
wire [4:1] P;
wire [4:1] C;

// Compute generate and propagate signals
genvar i;
generate
    for (i = 1; i <= 4; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] | B[i];
    end
endgenerate

// Compute carry signals
assign C[1] = Cin;
for (i = 2; i <= 4; i++) begin
    assign C[i] = G[i-1] | (P[i-1] & C[i-1]);
end

// Compute sum signals
assign S[1] = A[1] ^ B[1] ^ Cin;
for (i = 2; i <= 4; i++) begin
    assign S[i] = A[i] ^ B[i] ^ C[i-1];
end

// Compute carry-out
assign Cout = G[4] | (P[4] & C[4]);

endmodule

// 16-bit carry-lookahead adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input Cin,
    output [16:1] S,
    output Cout
);

wire [16:1] G;
wire [16:1] P;
wire [16:1] C;

// Compute generate and propagate signals
genvar i;
generate
    for (i = 1; i <= 16; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] | B[i];
    end
endgenerate

// Compute carry signals
assign C[1] = Cin;
for (i = 2; i <= 4; i++) begin
    assign C[i] = G[i-1] | (P[i-1] & C[i-1]);
end
for (i = 5; i <= 8; i++) begin
    assign C[i] = G[i-1] | (P[i-1] & C[i-1]);
end
for (i = 9; i <= 12; i++) begin
    assign C[i] = G[i-1] | (P[i-1] & C[i-1]);
end
for (i = 13; i <= 16; i++) begin
    assign C[i] = G[i-1] | (P[i-1] & C[i-1]);
end

// Compute sum signals
assign S[1] = A[1] ^ B[1] ^ Cin;
for (i = 2; i <= 16; i++) begin
    assign S[i] = A[i] ^ B[i] ^ C[i-1];
end

// Compute carry-out
assign Cout = G[16] | (P[16] & C[16]);

endmodule

// 32-bit carry-lookahead adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

wire C16;

cla_16bit uut1(
    .A(A[16:1]),
    .B(B[16:1]),
    .Cin(1'b0),
    .S(S[16:1]),
    .Cout(C16)
);

cla_16bit uut2(
    .A(A[32:17]),
    .B(B[32:17]),
    .Cin(C16),
    .S(S[32:17]),
    .Cout(C32)
);

endmodule