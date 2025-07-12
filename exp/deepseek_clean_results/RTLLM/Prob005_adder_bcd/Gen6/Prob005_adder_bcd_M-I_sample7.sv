module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Binary addition
    wire [4:0] sum_binary = A + B + Cin;
    
    // Overflow detection (sum > 9)
    wire overflow = (sum_binary[4]) ||  // Carry out indicates sum >=16
                   (sum_binary[3] & (sum_binary[2] | sum_binary[1]));  // Sum between 10-15
    
    // Pre-compute both possible results
    wire [3:0] sum_uncorrected = sum_binary[3:0];
    wire [3:0] sum_corrected = sum_uncorrected + 4'd6;
    
    // Output selection
    assign Sum = overflow ? sum_corrected : sum_uncorrected;
    assign Cout = overflow;

endmodule