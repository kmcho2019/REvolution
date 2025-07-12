// Improved module with optimized zero flag generation and consistent coding style
module alu #
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

    // Select between normal input and inverted input with added 1
    wire [WIDTH-1:0] b_selector;
    assign b_selector = do_sub ? (~b + 1) : b;

    // Perform addition or subtraction based on control signal
    assign out = a + b_selector;

    // Generate zero flag using a single assignment
    assign result_is_zero = !(|out); // Using bitwise NOR operation directly

endmodule

// Top-level module with improved coding style and comments
module TopModule (
    input logic do_sub,
    input logic [7:0] a,
    input logic [7:0] b,
    output logic [7:0] out,
    output logic result_is_zero
);

    // Instantiate ALU module with width parameter
    alu #(.WIDTH(8)) u_alu (
        .do_sub(do_sub),
        .a(a),
        .b(b),
        .out(out),
        .result_is_zero(result_is_zero)
    );

endmodule