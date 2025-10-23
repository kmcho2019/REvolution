module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute carry lookahead terms and binary sum
    wire [3:0] P = A ^ B;
    wire [3:0] G = A & B;
    wire C1 = G[0] | (P[0] & Cin);
    wire C2 = G[1] | (P[1] & C1);
    wire C3 = G[2] | (P[2] & C2);
    wire C4 = G[3] | (P[3] & C3);
    
    // Compute overflow and outputs directly
    assign Cout = C4 | ((P ^ {C3, C2, C1, Cin})[3] & 
                 ((P ^ {C3, C2, C1, Cin})[2] | (P ^ {C3, C2, C1, Cin})[1]);
    assign Sum = (Cout) ? (P ^ {C3, C2, C1, Cin}) + 4'd6 : 
                           (P ^ {C3, C2, C1, Cin});

endmodule