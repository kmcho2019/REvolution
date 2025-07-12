module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    // Calculate the two's complement of b
    wire [7:0] b_twos_complement;
    assign b_twos_complement = ~b + 1;

    // Select between b and its two's complement based on do_sub
    wire [7:0] b_selected;
    assign b_selected = do_sub ? b_twos_complement : b;

    // Perform addition
    assign out = a + b_selected;

    // Check if the result is zero using a comparator
    assign result_is_zero = (out == 8'b0) ? 1'b1 : 1'b0;

endmodule