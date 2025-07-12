module xnor1 #(
    parameter WIDTH = 1
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    output wire [WIDTH-1:0] y
);
    // Minimal 1-bit XNOR using built-in operator for optimal gate-level implementation
    assign y = a ~^ b;
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Instantiate parameterized 1-bit XNOR module to preserve modularity and scalability
    xnor1 #(.WIDTH(1)) u_xnor (
        .a(a),
        .b(b),
        .y(out)
    );
endmodule