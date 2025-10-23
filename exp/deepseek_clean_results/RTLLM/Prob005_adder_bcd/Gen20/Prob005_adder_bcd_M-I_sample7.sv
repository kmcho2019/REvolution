module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial sum with carry-out (5-bit)
    wire [4:0] sum_ext = A + B + Cin;
    
    // Simplified overflow detection
    wire overflow = (sum_ext[3:0] > 4'd9) | sum_ext[4];

    // Corrected sum calculation
    wire [3:0] corrected_sum = sum_ext[3:0] + 4'd6;
    
    // Select between original and corrected sum
    assign Sum = overflow ? corrected_sum : sum_ext[3:0];
    assign Cout = overflow;

endmodule