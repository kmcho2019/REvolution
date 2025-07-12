module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Generate and Propagate terms
    wire [3:0] P = A ^ B;
    wire [3:0] G = A & B;
    
    // Balanced carry computation (2-level tree)
    wire [1:0] G01 = {G[1], G[0]} | ({P[1], P[0]} & {G[0], Cin});
    wire [1:0] G23 = {G[3], G[2]} | ({P[3], P[2]} & {G[2], G01[1]});
    
    // Intermediate carries
    wire C1 = G01[0];
    wire C2 = G01[1];
    wire C3 = G23[0];
    wire C4 = G23[1];
    
    // Sum bits
    wire S0 = P[0] ^ Cin;
    wire S1 = P[1] ^ C1;
    wire S2 = P[2] ^ C2;
    wire S3 = P[3] ^ C3;
    
    // Overflow detection (sum > 9)
    wire overflow = C4 | (S3 & (S2 | S1));
    
    // Correction mux (implement +6 as bit patterns)
    assign Sum = overflow ? {S3, S2 ^ S1, S1, ~S0} : {S3, S2, S1, S0};
    assign Cout = overflow;

endmodule