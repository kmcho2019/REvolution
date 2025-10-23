module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Kogge-Stone parallel prefix adder
    // Stage 1: Generate and propagate
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    
    // Stage 2: First prefix level
    wire [3:1] G1;
    wire [3:1] P1;
    
    assign G1[1] = G[1] | (P[1] & G[0]);
    assign P1[1] = P[1] & P[0];
    assign G1[2] = G[2] | (P[2] & G[1]);
    assign P1[2] = P[2] & P[1];
    assign G1[3] = G[3] | (P[3] & G[2]);
    assign P1[3] = P[3] & P[2];
    
    // Stage 3: Second prefix level
    wire [3:2] G2;
    wire [3:2] P2;
    
    assign G2[2] = G1[2] | (P1[2] & G[0]);
    assign P2[2] = P1[2] & P[0];
    assign G2[3] = G1[3] | (P1[3] & G1[1]);
    assign P2[3] = P1[3] & P1[1];
    
    // Final carries
    wire C1 = G[0] | (P[0] & Cin);
    wire C2 = G1[1] | (P1[1] & Cin);
    wire C3 = G2[2] | (P2[2] & Cin);
    wire C4 = G2[3] | (P2[3] & Cin);
    
    // Sum computation
    wire [3:0] sum_uncorrected = P ^ {C3, C2, C1, Cin};
    
    // Optimized overflow detection
    wire overflow = C4 | (sum_uncorrected[3] & sum_uncorrected[2]) | 
                   (sum_uncorrected[3] & sum_uncorrected[1]);
    
    // Conditional correction computation
    wire [3:0] sum_corrected = overflow ? (sum_uncorrected + 4'd6) : sum_uncorrected;
    
    assign Sum = sum_corrected;
    assign Cout = overflow;
    
endmodule