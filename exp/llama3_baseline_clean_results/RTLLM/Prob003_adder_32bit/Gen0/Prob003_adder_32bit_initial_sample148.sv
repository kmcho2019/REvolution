module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out
);

wire [16:1] G; // Generate signal
wire [16:1] P; // Propagate signal
wire [15:0] C; // Internal carries

// Calculate generate and propagate signals
genvar i;
generate
    for (i = 1; i <= 16; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] | B[i];
    end
endgenerate

// Calculate internal carries
assign C[0] = C_in;
generate
    for (i = 1; i <= 15; i++) begin
        assign C[i] = G[i] | (P[i] & C[i-1]);
    end
endgenerate

assign C_out = G[16] | (P[16] & C[15]);

// Calculate sum
generate
    for (i = 1; i <= 16; i++) begin
        assign S[i] = A[i] ^ B[i] ^ C[i-1];
    end
endgenerate

endmodule


module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

wire C16; // Carry out from the first 16-bit CLA

cla_16bit cla_low(
    .A(A[16:1]),
    .B(B[16:1]),
    .C_in(1'b0),
    .S(S[16:1]),
    .C_out(C16)
);

cla_16bit cla_high(
    .A(A[32:17]),
    .B(B[32:17]),
    .C_in(C16),
    .S(S[32:17]),
    .C_out(C32)
);

endmodule