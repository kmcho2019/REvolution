// Define the ALU module
module alu #
(
    parameter WIDTH = 8
)
(
    input logic do_sub,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out,
    output logic result_is_zero
);

    // Perform addition or subtraction
    assign out = do_sub? (a - b) : (a + b);

    // Generate zero flag
    assign result_is_zero = ~(| out);

endmodule

// Define the top-level module
module TopModule (
    input logic do_sub,
    input [7:0] a,
    input [7:0] b,
    output logic [7:0] out,
    output logic result_is_zero
);

    // Instantiate the ALU module
    alu #(.WIDTH(8)) u_alu (
      .do_sub(do_sub),
      .a(a),
      .b(b),
      .out(out),
      .result_is_zero(result_is_zero)
    );

endmodule