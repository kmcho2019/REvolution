module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] add_result;
    wire [7:0] sub_result;

    // Perform addition and subtraction in parallel
    assign add_result = a + b;
    assign sub_result = a - b;

    // Use a multiplexor to select the output based on do_sub
    assign out = do_sub? sub_result : add_result;

    // Set the zero flag based on the selected output
    assign result_is_zero = (out == 8'b0)? 1'b1 : 1'b0;

endmodule