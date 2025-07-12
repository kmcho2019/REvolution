module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Group Generate and Propagate terms
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    
    // Parallel carry computation
    wire C0 = Cin;
    wire C1 = G[0] | (P[0] & C0);
    wire C2 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C0);
    wire C3 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C0);
    wire C4 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | 
              (P[3] & P[2] & P[1] & P[0] & C0);
    
    // Sum before correction
    wire [3:0] sum_uncorrected = P ^ {C3, C2, C1, C0};
    
    // Optimized overflow detection (sum > 9)
    wire overflow = C4 | (&sum_uncorrected[3:2]) | (sum_uncorrected[3] & |sum_uncorrected[1:0]);
    
    // Precomputed corrected values (power-efficient mux implementation)
    wire [3:0] sum_plus_6 = sum_uncorrected + 4'd6;
    assign Sum = overflow ? sum_plus_6 : sum_uncorrected;
    assign Cout = overflow;

endmodule