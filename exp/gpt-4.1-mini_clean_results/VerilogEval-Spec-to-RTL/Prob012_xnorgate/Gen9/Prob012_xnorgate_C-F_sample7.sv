module xnor_gate #(
    parameter WIDTH = 1
)(
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH-1:0] y
);
    // Efficient direct XNOR implementation using built-in operator
    assign y = ~(a ^ b);
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Instantiate parameterized XNOR gate for modularity and clarity
    xnor_gate #(.WIDTH(1)) u_xnor (
        .a(a),
        .b(b),
        .y(out)
    );
endmodule