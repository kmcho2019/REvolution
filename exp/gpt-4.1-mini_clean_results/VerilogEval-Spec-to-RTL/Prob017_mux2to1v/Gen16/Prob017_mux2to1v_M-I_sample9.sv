module Mux2to1 #(
    parameter WIDTH = 1
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);
    // Direct vector-wide conditional assignment for optimal mux inference
    assign out = sel ? b : a;
endmodule

module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    Mux2to1 #(.WIDTH(100)) u_mux (
        .a   (a),
        .b   (b),
        .sel (sel),
        .out (out)
    );
endmodule