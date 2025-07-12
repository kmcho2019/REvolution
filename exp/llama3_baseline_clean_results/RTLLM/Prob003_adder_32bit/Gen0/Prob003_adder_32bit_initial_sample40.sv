// Define the 16-bit CLA block
module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input        Cin,
    output [16:1] S,
    output       Cout
);

    wire [15:0] G, P;
    wire [15:0] C;

    // Calculate Generate (G) and Propagate (P) signals
    genvar i;
    generate
        for (i = 1; i <= 16; i++) begin
            assign G[i-1] = A[i] & B[i];
            assign P[i-1] = A[i] | B[i];
        end
    endgenerate

    // Calculate Carry (C) signals
    assign C[0] = Cin;
    for (genvar j = 1; j < 16; j++) begin
        assign C[j] = G[j-1] | (P[j-1] & C[j-1]);
    end

    // Calculate Sum (S) signals
    assign S[1] = A[1] ^ B[1] ^ Cin;
    for (genvar k = 2; k <= 16; k++) begin
        assign S[k] = A[k] ^ B[k] ^ C[k-1];
    end

    // Calculate Cout
    assign Cout = G[15] | (P[15] & C[15]);

endmodule

// Define the 32-bit adder
module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output       C32
);

    wire C16;

    // Instantiate two 16-bit CLA blocks
    cla_16bit cla_lower (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16)
    );

    cla_16bit cla_upper (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );

endmodule