module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    // Internal wire for the sum before BCD correction
    wire [4:0] sum_before_correction;

    // Perform binary addition of A, B, and Cin
    assign sum_before_correction = {1'b0, A} + {1'b0, B} + {3'b000, Cin};

    // Determine the carry-out (Cout)
    assign Cout = (sum_before_correction > 9) ? 1'b1 : 1'b0;

    // Apply BCD correction if necessary and assign to Sum
    assign Sum = (sum_before_correction > 9) ? sum_before_correction + 6 : sum_before_correction;

endmodule