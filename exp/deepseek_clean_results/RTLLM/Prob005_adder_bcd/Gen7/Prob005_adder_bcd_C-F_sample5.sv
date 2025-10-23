module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Generate and Propagate terms
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    
    // Carry computation
    wire C0 = Cin;
    wire C1 = G[0] | (P[0] & C0);
    wire C2 = G[1] | (P[1] & C1);
    wire C3 = G[2] | (P[2] & C2);
    wire C4 = G[3] | (P[3] & C3);
    
    // Sum before correction
    wire [3:0] sum_uncorrected = P ^ {C3, C2, C1, C0};
    
    // Overflow detection (sum > 9 or carry out)
    wire overflow = C4 | (sum_uncorrected[3] & (sum_uncorrected[2] | sum_uncorrected[1]));
    
    // Corrected sum (mux implementation)
    wire [3:0] sum_corrected = overflow ? sum_uncorrected + 4'd6 : sum_uncorrected;
    
    // Output assignments
    assign Sum = sum_corrected;
    assign Cout = overflow;

endmodule