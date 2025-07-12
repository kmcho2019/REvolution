// Define the module for a 16-bit CLA block
module cla_16bit(A, B, Cin, S, Cout);
    input [16:1] A, B;
    input Cin;
    output [16:1] S;
    output Cout;

    // Generate signals for the CLA
    wire [16:1] G, P;
    assign G = A & B;
    assign P = A | B;

    // Calculate carry generate and propagate signals for each bit
    wire [16:1] C;
    assign C[1] = G[1] | (P[1] & Cin);

    // For the rest of the bits
    genvar i;
    generate
        for (i = 2; i <= 16; i = i + 1) begin: cla_gen
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    // Calculate the sum
    assign S = A ^ B ^ C;

    // Calculate the final carry-out
    assign Cout = G[16] | (P[16] & C[15]);
endmodule

// Define the top module for a 32-bit CLA
module adder_32bit(A, B, S, C32);
    input [32:1] A, B;
    output [32:1] S;
    output C32;

    // Declare wires for the internal signals
    wire [16:1] S_lo, S_hi;
    wire Cin_lo, Cout_lo, Cin_hi, Cout_hi;

    // Instantiate two 16-bit CLA blocks
    cla_16bit cla_lo(A[16:1], B[16:1], 1'b0, S_lo, Cout_lo);
    cla_16bit cla_hi(A[32:17], B[32:17], Cout_lo, S_hi, Cout_hi);

    // Connect the carry-out from the lower 16-bit block to the carry-in of the upper 16-bit block
    assign Cin_hi = Cout_lo;

    // Combine the sums from the two blocks
    assign S[16:1] = S_lo;
    assign S[32:17] = S_hi;

    // Assign the final carry-out
    assign C32 = Cout_hi;
endmodule