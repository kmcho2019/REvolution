module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Stage 1: Compute initial sum including carry-in
    wire [4:0] raw_sum = A + B + Cin;
    
    // Stage 2: Overflow detection (sum > 9)
    wire overflow = (raw_sum[4]) ||              // Carry occurred
                   (raw_sum[3] & (raw_sum[2] | raw_sum[1]));  // Sum 10-15
    
    // Stage 3: Apply correction if needed
    wire [3:0] corrected_sum = overflow ? (raw_sum[3:0] + 4'd6) : raw_sum[3:0];
    
    // Output assignments
    assign Sum = corrected_sum;
    assign Cout = overflow;

endmodule