module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Optimized carry lookahead for first 2 bits (reduces critical path)
    wire G0 = A[0] & B[0];
    wire P0 = A[0] ^ B[0];
    wire C1 = G0 | (P0 & Cin);
    
    wire G1 = A[1] & B[1];
    wire P1 = A[1] ^ B[1];
    wire C2 = G1 | (P1 & C1);
    
    // Compute sum bits 1:0 early
    wire [1:0] sum_low = {P1, P0} ^ {C1, Cin};
    
    // Ripple carry for upper bits (better area/power tradeoff)
    wire [3:2] sum_high = A[3:2] ^ B[3:2] ^ {C2, C2};
    wire C3 = (A[2] & B[2]) | ((A[2] ^ B[2]) & C2);
    wire C4 = (A[3] & B[3]) | ((A[3] ^ B[3]) & C3);
    
    // Combine all sum bits
    wire [3:0] sum_uncorrected = {sum_high, sum_low};
    
    // Early overflow detection (sum >9 or carry out)
    // Optimized to use only necessary bits
    wire overflow = C4 | (sum_uncorrected[3] & (sum_uncorrected[2] | sum_uncorrected[1]));
    
    // Efficient correction application
    assign Sum = overflow ? (sum_uncorrected + 4'd6) : sum_uncorrected;
    assign Cout = overflow;
    
endmodule