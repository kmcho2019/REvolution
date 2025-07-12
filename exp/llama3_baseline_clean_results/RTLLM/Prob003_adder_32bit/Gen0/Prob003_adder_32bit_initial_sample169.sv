// Define a module for a 16-bit carry-lookahead adder
module cla_16bit(A, B, Cin, S, Cout);
    input [15:1] A, B;
    input Cin;
    output [15:1] S;
    output Cout;

    // Internal wires
    wire [15:1] G, P;
    wire [14:1] C;

    // Calculate Generate (G) and Propagate (P) signals
    assign G = A & B;
    assign P = A | B;

    // Calculate the carry signals
    assign C[1] = G[1] | (P[1] & Cin);
    assign S[1] = P[1] ^ Cin;

    // Use a loop to generate the rest of the carry and sum bits
    generate
        for (genvar i = 2; i <= 15; i++) begin
            assign C[i] = G[i] | (P[i] & C[i-1]);
            assign S[i] = P[i] ^ C[i-1];
        end
    endgenerate

    // The final carry-out is the carry from the last bit
    assign Cout = C[15];
endmodule

// Define the top-level 32-bit carry-lookahead adder module
module adder_32bit(A, B, S, C32);
    input [32:1] A, B;
    output [32:1] S;
    output C32;

    // Internal wires for the carry between the two 16-bit blocks
    wire C16;

    // Instantiate two 16-bit carry-lookahead adder blocks
    cla_16bit lower_bits(.A(A[16:1]), .B(B[16:1]), .Cin(1'b0), .S(S[16:1]), .Cout(C16));
    cla_16bit upper_bits(.A(A[32:17]), .B(B[32:17]), .Cin(C16), .S(S[32:17]), .Cout(C32));
endmodule