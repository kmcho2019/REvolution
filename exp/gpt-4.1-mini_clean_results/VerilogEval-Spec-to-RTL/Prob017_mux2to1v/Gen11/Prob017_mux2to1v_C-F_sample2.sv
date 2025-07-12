module Mux2to1_Nbit #(
    parameter WIDTH = 100
) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);
    // Vectorized 2-to-1 mux for efficient combinational logic
    assign out = sel ? b : a;
endmodule

module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Single instance of 100-bit wide vector mux
    Mux2to1_Nbit #(.WIDTH(100)) top_mux (
        .a   (a),
        .b   (b),
        .sel (sel),
        .out (out)
    );
endmodule