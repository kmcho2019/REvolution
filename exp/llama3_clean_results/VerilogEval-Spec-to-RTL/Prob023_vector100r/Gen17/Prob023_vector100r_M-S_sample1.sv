module TopModule #(
    parameter WIDTH = 100
)(
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

assign out = in [WIDTH-1:0];

// or more explicitly for reversal:
assign out = {<<{in}};

endmodule