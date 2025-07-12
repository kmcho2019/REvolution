// Module for addition/subtraction logic and zero flag generation
module add_sub_zero_flag #
(
    parameter WIDTH = 8
)
(
    input logic do_sub,
    input logic [WIDTH-1:0] a,
    input logic [WIDTH-1:0] b,
    output logic [WIDTH-1:0] out,
    output logic result_is_zero
);

    // Perform addition or subtraction based on control signal
    logic [WIDTH-1:0] result;
    assign result = do_sub ? (a - b) : (a + b);

    // Generate zero flag using bitwise NOR operation
    assign result_is_zero = ~(| result);

    // Assign result to output
    assign out = result;

endmodule

// Top-level module with improved coding style and comments
module TopModule (
    input logic do_sub,
    input logic [7:0] a,
    input logic [7:0] b,
    output logic [7:0] out,
    output logic result_is_zero
);

    // Instantiate add_sub_zero_flag module with width parameter
    add_sub_zero_flag #(.WIDTH(8)) u_add_sub_zero_flag (
        .do_sub(do_sub),
        .a(a),
        .b(b),
        .out(out),
        .result_is_zero(result_is_zero)
    );

endmodule