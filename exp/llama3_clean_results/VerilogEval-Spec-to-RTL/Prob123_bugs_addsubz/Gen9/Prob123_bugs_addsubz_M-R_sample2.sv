// Module for addition/subtraction logic
module add_sub #
(
    parameter WIDTH = 8
)
(
    input logic do_sub,
    input logic [WIDTH-1:0] a,
    input logic [WIDTH-1:0] b,
    output logic [WIDTH-1:0] out
);

    // Perform addition or subtraction based on control signal
    assign out = do_sub ? (a - b) : (a + b);

endmodule

// Module for zero flag generation
module zero_flag #
(
    parameter WIDTH = 8
)
(
    input logic [WIDTH-1:0] in,
    output logic result_is_zero
);

    // Generate zero flag using bitwise NOR operation
    assign result_is_zero = ~(| in);

endmodule

// Top-level module with improved coding style and comments
module TopModule (
    input logic do_sub,
    input logic [7:0] a,
    input logic [7:0] b,
    output logic [7:0] out,
    output logic result_is_zero
);

    // Instantiate add_sub module with width parameter
    wire [7:0] add_sub_result;
    add_sub #(.WIDTH(8)) u_add_sub (
        .do_sub(do_sub),
        .a(a),
        .b(b),
        .out(add_sub_result)
    );

    // Instantiate zero_flag module with width parameter
    zero_flag #(.WIDTH(8)) u_zero_flag (
        .in(add_sub_result),
        .result_is_zero(result_is_zero)
    );

    // Assign result to output
    assign out = add_sub_result;

endmodule