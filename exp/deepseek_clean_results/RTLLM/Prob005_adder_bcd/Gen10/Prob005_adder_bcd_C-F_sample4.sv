module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial 5-bit sum (including carry-out)
    wire [4:0] initial_sum = A + B + Cin;

    // Efficient BCD correction condition:
    // True when sum > 9 or when there's a carry-out
    wire correction_needed = initial_sum[4] | 
                           (initial_sum[3] & (initial_sum[2] | initial_sum[1]));

    // Apply correction by adding 6 when needed (wrapped in 4 bits)
    wire [3:0] corrected_sum = initial_sum[3:0] + {1'b0, correction_needed, 2'b10};

    // Output assignments
    assign Sum = corrected_sum;
    assign Cout = correction_needed;

endmodule