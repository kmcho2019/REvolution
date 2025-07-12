module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Binary addition with carry lookahead
    wire [3:0] P = A ^ B;
    wire [3:0] G = A & B;
    
    wire C1 = G[0] | (P[0] & Cin);
    wire C2 = G[1] | (P[1] & C1);
    wire C3 = G[2] | (P[2] & C2);
    wire C4 = G[3] | (P[3] & C3);
    
    wire [3:0] sum_uncorrected = P ^ {C3, C2, C1, Cin};
    
    // Efficient overflow detection (sum > 9)
    wire overflow = C4 | (sum_uncorrected[3] & (sum_uncorrected[2] | sum_uncorrected[1]));
    
    // Conditional correction - only compute when needed
    wire [3:0] sum_corrected = overflow ? (sum_uncorrected + 4'd6) : 4'd0;
    
    // Select correct sum and generate carry
    assign Sum = overflow ? sum_corrected : sum_uncorrected;
    assign Cout = overflow;

endmodule