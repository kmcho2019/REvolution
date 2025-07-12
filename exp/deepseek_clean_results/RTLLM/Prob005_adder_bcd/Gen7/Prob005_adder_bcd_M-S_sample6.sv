module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute 4-bit sum first
    wire [3:0] raw_sum = A + B + Cin;
    
    // Check if correction needed (sum > 9)
    wire correction_needed = (raw_sum > 4'd9);
    
    // Apply correction and generate carry
    assign Sum = correction_needed ? raw_sum + 4'd6 : raw_sum;
    assign Cout = correction_needed;

endmodule