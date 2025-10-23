// Define the 16-bit Carry-Lookahead Adder (CLA) module
module cla_16bit(
    input [15:1] A,
    input [15:1] B,
    input Cin,
    output [15:1] S,
    output Cout
);

// Generate the carry signals for each bit position
wire [15:1] G;  // Generate
wire [15:1] P;  // Propagate
wire [14:1] C;  // Internal carry signals

// Calculate the generate and propagate signals
genvar i;
generate
    for (i = 1; i <= 15; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] | B[i];
    end
endgenerate

// Calculate the internal carry signals
assign C[1] = G[1];
generate
    for (i = 2; i <= 14; i++) begin
        assign C[i] = G[i] | (P[i] & C[i-1]);
    end
endgenerate

// Calculate the carry-out signal
assign Cout = G[15] | (P[15] & C[14]);

// Calculate the sum signals
assign S[1] = A[1] ^ B[1] ^ Cin;
generate
    for (i = 2; i <= 15; i++) begin
        assign S[i] = A[i] ^ B[i] ^ C[i-1];
    end
endgenerate

endmodule

// Define the 32-bit carry-lookahead adder module
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

// Instantiate two 16-bit CLA blocks
wire [15:1] S_lower;
wire Cout_lower;
cla_16bit cla_lower(
    .A(A[16:1]),
    .B(B[16:1]),
    .Cin(1'b0),
    .S(S_lower),
    .Cout(Cout_lower)
);

cla_16bit cla_upper(
    .A(A[32:17]),
    .B(B[32:17]),
    .Cin(Cout_lower),
    .S(S[32:17]),
    .Cout(C32)
);

// Assign the sum signals
assign S[16:1] = S_lower;

endmodule