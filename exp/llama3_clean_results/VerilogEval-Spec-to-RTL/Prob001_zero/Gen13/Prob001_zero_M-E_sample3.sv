// Parameterized TopModule for outputs of variable width
module TopModule #
(
    parameter WIDTH = 1
)
(
    output [WIDTH-1:0] zero
);

// Assign all zeros to the output, based on the parameterized width
assign zero = {WIDTH{1'b0}};

endmodule