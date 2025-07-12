module Mux2to1_Nbit #(
    parameter WIDTH = 100
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);
    // Vectorized 2-to-1 mux using conditional assignment for minimal combinational logic
    assign out = sel ? b : a;
endmodule

module TopModule(
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Instantiate one single 100-bit mux module for the entire bus
    Mux2to1_Nbit #(.WIDTH(100)) mux_inst (
        .a   (a),
        .b   (b),
        .sel (sel),
        .out (out)
    );
endmodule