module cla_16bit (
    input  wire [16:1] A,
    input  wire [16:1] B,
    input  wire        Cin,
    output wire [16:1] S,
    output wire        Cout,
    output wire        P,   // Block propagate
    output wire        G    // Block generate
);
    wire [16:1] P_bit = A ^ B;  // Propagate signals per bit
    wire [16:1] G_bit = A & B;  // Generate signals per bit

    // Function to compute carry vector from generate and propagate signals and Cin
    function [16:0] calc_carry;
        input [16:1] g;
        input [16:1] p;
        input        cin;
        reg   [16:0] c;
        integer i;
        begin
            c[0] = cin;
            for (i = 1; i <= 16; i = i + 1) begin
                c[i] = g[i] | (p[i] & c[i-1]);
            end
            calc_carry = c;
        end
    endfunction

    // Compute carry signals
    wire [16:0] C = calc_carry(G_bit, P_bit, Cin);

    // Sum bits
    assign S = P_bit ^ C[16:1];

    // Final carry out
    assign Cout = C[16];

    // Block propagate: all bits propagate
    assign P = &P_bit;

    // Block generate: carry generate for block (Cin=0)
    wire [16:0] block_carry_zero = calc_carry(G_bit, P_bit, 1'b0);
    assign G = block_carry_zero[16];

endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    wire C16;
    wire P_low, G_low;
    wire P_high, G_high;

    // Instantiate lower 16-bit CLA block (bits 1 to 16)
    cla_16bit cla_low (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16),
        .P   (P_low),
        .G   (G_low)
    );

    // Carry-in to upper block computed via block propagate/generate
    wire Cin_high = G_low | (P_low & 1'b0);  // Since Cin=0 for low block, just G_low

    // Instantiate upper 16-bit CLA block (bits 17 to 32)
    cla_16bit cla_high (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (Cin_high),
        .S   (S[32:17]),
        .Cout(C32),
        .P   (P_high),
        .G   (G_high)
    );

    // Optional: if needed, the overall 32-bit block propagate and generate could be computed,
    // but not required for this problem.

endmodule