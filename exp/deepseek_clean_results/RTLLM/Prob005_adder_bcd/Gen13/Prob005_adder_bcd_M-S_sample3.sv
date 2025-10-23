module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial sum including carry-out
    wire [4:0] sum_raw = A + B + Cin;
    
    // Detect if sum > 9 (needs correction)
    wire overflow = (sum_raw[4]) ||          // sum >= 16
                   (sum_raw[3] & (sum_raw[2] | sum_raw[1]));  // sum between 10-15
    
    // Compute corrected sum (raw sum + 6)
    wire [3:0] sum_corrected = sum_raw[3:0] + 4'b0110;
    
    // Select between raw and corrected sum
    assign Sum = overflow ? sum_corrected : sum_raw[3:0];
    assign Cout = overflow;

endmodule