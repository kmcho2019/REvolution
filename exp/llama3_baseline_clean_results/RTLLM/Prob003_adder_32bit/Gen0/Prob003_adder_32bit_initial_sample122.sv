// Define the 16-bit carry-lookahead adder module
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out
);

// Generate and propagate signals
wire [15:0] G, P;
genvar i;
generate
    for (i = 1; i <= 16; i++) begin
        assign G[i-1] = A[i] & B[i];
        assign P[i-1] = A[i] | B[i];
    end
endgenerate

// Carry calculation
wire [16:1] C;
assign C[1] = C_in;
genvar j;
generate
    for (j = 2; j <= 16; j++) begin
        assign C[j] = G[j-2] | (P[j-2] & C[j-1]);
    end
endgenerate

// Sum calculation
genvar k;
generate
    for (k = 1; k <= 16; k++) begin
        assign S[k] = A[k] ^ B[k] ^ C[k];
    end
endgenerate

// Carry out
assign C_out = G[15] | (P[15] & C[16]);

endmodule

// Define the 32-bit carry-lookahead adder module
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

// Lower 16-bit CLA block
wire [16:1] S_low;
wire C_low;
cla_16bit cla_low(
    .A(A[16:1]),
    .B(B[16:1]),
    .C_in(1'b0),
    .S(S_low),
    .C_out(C_low)
);

// Upper 16-bit CLA block
wire [16:1] S_high;
wire C_high;
cla_16bit cla_high(
    .A(A[32:17]),
    .B(B[32:17]),
    .C_in(C_low),
    .S(S_high),
    .C_out(C_high)
);

// Final sum and carry
assign S[16:1] = S_low;
assign S[32:17] = S_high;
assign C32 = C_high;

endmodule