module xnor_gate #(
    parameter WIDTH = 1
)(
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH-1:0] y
);
    assign y = ~(a ^ b);
endmodule

module TopModule (
    input  a,
    input  b,
    output out
);
    xnor_gate #(.WIDTH(1)) u_xnor (
        .a(a),
        .b(b),
        .y(out)
    );
endmodule