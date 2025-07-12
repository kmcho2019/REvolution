module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial sum with carry-in (5-bit)
    wire [4:0] sum_ext = A + B + Cin;
    
    // Optimized overflow detection: sum > 9
    wire overflow = (sum_ext[3:0] > 4'd9) | sum_ext[4];
    
    // Corrected sum is either sum+6 or original sum
    wire [3:0] corrected_sum = sum_ext[3:0] + 4'd6;
    
    // Select appropriate sum based on overflow
    assign Sum = overflow ? corrected_sum : sum_ext[3:0];
    assign Cout = overflow;

endmodule