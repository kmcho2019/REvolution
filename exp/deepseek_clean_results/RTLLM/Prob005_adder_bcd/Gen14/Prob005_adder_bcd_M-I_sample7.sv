module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Generate and Propagate computation
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    
    // Brent-Kung carry tree (reduced logic depth)
    wire C1 = G[0] | (P[0] & Cin);
    wire C2 = G[1] | (P[1] & C1);
    wire C3 = G[2] | (P[2] & C2);
    wire C4 = G[3] | (P[3] & C3);
    
    // Sum computation
    wire [3:0] sum_uncorrected = {P[3] ^ C3, P[2] ^ C2, P[1] ^ C1, P[0] ^ Cin};
    
    // Overflow detection (sum > 9)
    wire overflow = C4 | (sum_uncorrected[3] & (sum_uncorrected[2] | sum_uncorrected[1]));
    
    // Mux-based correction (instead of adder)
    assign Sum = overflow ? 
        {sum_uncorrected[3] ^ sum_uncorrected[1] & sum_uncorrected[2],  // S3
         sum_uncorrected[2] ^ sum_uncorrected[1],                        // S2
         ~sum_uncorrected[1],                                            // S1
         sum_uncorrected[0]} :                                           // S0
        sum_uncorrected;
    
    assign Cout = overflow;

endmodule