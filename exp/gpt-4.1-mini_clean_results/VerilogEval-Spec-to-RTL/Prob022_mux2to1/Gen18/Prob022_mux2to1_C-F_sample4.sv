// TopModule: 1-bit 2-to-1 Multiplexer using concise continuous assignment
// with clear explanation and parameterization for scalability

module TopModule #(
    parameter WIDTH = 1  // Data width, default to 1-bit
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);

// The multiplexer chooses 'a' when sel=0 and 'b' when sel=1.
// This is equivalent to: out = (sel AND b) OR (NOT sel AND a)
// but written compactly using the ternary operator for synthesis efficiency.
assign out = sel ? b : a;

endmodule