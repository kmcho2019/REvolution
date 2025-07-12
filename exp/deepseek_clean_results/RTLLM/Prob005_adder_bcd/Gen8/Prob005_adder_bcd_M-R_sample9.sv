module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Binary sum with carry lookahead
    wire [3:0] P = A ^ B;
    wire [3:0] G = A & B;
    
    wire C1 = G[0] | (P[0] & Cin);
    wire C2 = G[1] | (P[1] & C1);
    wire C3 = G[2] | (P[2] & C2);
    wire C4 = G[3] | (P[3] & C3);
    
    wire [3:0] sum_uncorrected = P ^ {C3, C2, C1, Cin};
    
    // Combined overflow detection and correction
    assign Cout = C4 | (sum_uncorrected[3] & (sum_uncorrected[2] | sum_uncorrected[1]));
    assign Sum = sum_uncorrected + (Cout ? 4'd6 : 4'd0);

endmodule