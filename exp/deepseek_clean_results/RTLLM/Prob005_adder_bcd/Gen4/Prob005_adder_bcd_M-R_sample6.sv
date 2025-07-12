module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute sum and carry in one expression
    wire [3:0] P = A ^ B;
    wire [3:0] G = A & B;
    
    // Carry computation chained in single expression
    wire C4 = G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin)))))));
    
    // Compute uncorrected sum
    wire [3:0] sum_uncorrected = P ^ {G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin))))),
                      G[1] | (P[1] & (G[0] | (P[0] & Cin))),
                      G[0] | (P[0] & Cin),
                      Cin};
    
    // Combined overflow detection and correction
    assign Cout = C4 | (sum_uncorrected[3] & (sum_uncorrected[2] | sum_uncorrected[1]));
    assign Sum = sum_uncorrected + (Cout ? 4'd6 : 4'd0);

endmodule