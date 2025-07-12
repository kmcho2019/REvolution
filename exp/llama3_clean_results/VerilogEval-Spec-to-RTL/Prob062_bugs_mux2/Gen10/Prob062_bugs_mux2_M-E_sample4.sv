// Parameterized 2-to-1 multiplexer module
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

    // Use a for-loop to generate the output vector based on the select signal
    always @(a, b, sel) begin
        for (int i = 0; i < WIDTH; i++) begin
            out[i] = sel? b[i] : a[i];
        end
    end

endmodule