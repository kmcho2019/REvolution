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
    
    // Carry computation using continuous assignment
    wire C0 = Cin;
    wire C1 = G[0] | (P[0] & C0);
    wire C2 = G[1] | (P[1] & C1);
    wire C3 = G[2] | (P[2] & C2);
    wire C4 = G[3] | (P[3] & C3);
    
    // Binary sum before correction
    wire [3:0] sum_uncorrected = {P[3] ^ C3, P[2] ^ C2, P[1] ^ C1, P[0] ^ C0};
    
    // Overflow occurs if sum >9 or carry out
    wire overflow = (sum_uncorrected > 4'd9) | C4;
    
    // Pre-compute both possible results
    wire [3:0] sum_corrected = sum_uncorrected + 4'd6;
    
    // Select correct sum based on overflow
    assign Sum = overflow ? sum_corrected : sum_uncorrected;
    assign Cout = overflow;

endmodule