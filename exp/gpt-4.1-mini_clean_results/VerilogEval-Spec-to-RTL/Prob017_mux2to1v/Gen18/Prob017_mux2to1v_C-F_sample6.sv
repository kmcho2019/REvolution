module Mux2to1_Nbit #(
    parameter WIDTH = 100
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);
    // Efficient vectorized 2-to-1 mux using conditional assignment
    assign out = sel ? b : a;
endmodule

module TopModule #(
    parameter WIDTH = 100
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);
    // Instantiate one single 100-bit mux module for entire bus
    Mux2to1_Nbit #(.WIDTH(WIDTH)) mux_inst (
        .a   (a),
        .b   (b),
        .sel (sel),
        .out (out)
    );
endmodule