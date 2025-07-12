// Parameterized 2-to-1 multiplexer module with direct assignment
module ParametricMux #
(
    parameter WIDTH = 8 // Default width of the input vectors
)
(
    input        sel, // Select signal
    input  [WIDTH-1:0] a, // First input vector
    input  [WIDTH-1:0] b, // Second input vector
    output [WIDTH-1:0] out // Selected output vector
);

    // Use a continuous assignment to directly generate the output vector
    assign out = sel ? b : a;

endmodule