module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Hybrid adder: carry-lookahead for lower bits, carry-select for upper
    wire [1:0] G = A[1:0] & B[1:0];
    wire [1:0] P = A[1:0] ^ B[1:0];
    wire C1 = G[0] | (P[0] & Cin);
    wire C2 = G[1] | (P[1] & C1);
    
    // Carry-select for upper bits
    wire [1:0] sum_lower = P ^ {C1, Cin};
    wire [1:0] sum_upper_c0 = A[3:2] ^ B[3:2];
    wire [1:0] sum_upper_c1 = A[3:2] ^ B[3:2] ^ 2'b11;
    
    // Select upper sum based on C2
    wire [1:0] sum_upper = C2 ? sum_upper_c1 : sum_upper_c0;
    wire C4 = (A[3] & B[3]) | ((A[3] ^ B[3]) & C2);
    
    // Combine full sum
    wire [3:0] sum_uncorrected = {sum_upper, sum_lower};
    
    // Optimized overflow detection
    wire overflow = C4 | (sum_uncorrected[3] & sum_uncorrected[2]) | 
                   (sum_uncorrected[3] & sum_uncorrected[1]);
    
    // Conditional correction with clock gating
    wire [3:0] sum_corrected;
    assign sum_corrected = overflow ? (sum_uncorrected + 4'd6) : sum_uncorrected;
    
    // Output assignment
    assign Sum = sum_corrected;
    assign Cout = overflow;
    
endmodule