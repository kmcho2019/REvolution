module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Binary addition including carry-in
    wire [4:0] binary_sum = A + B + Cin;
    
    // Detect if sum exceeds 9 or generated carry (clear condition from Example 1)
    wire needs_correction = (binary_sum > 5'd9) || binary_sum[4];
    
    // Efficient correction logic from Example 2
    wire [3:0] correction = {4{needs_correction}} & 4'd6;
    
    // Single final addition with correction (optimized from Example 2)
    wire [4:0] final_sum = binary_sum + {1'b0, correction};
    
    // Output assignments
    assign Sum = final_sum[3:0];
    assign Cout = final_sum[4];

endmodule