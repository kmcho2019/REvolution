module Mux2to1_Nbit #(
    parameter WIDTH = 1
) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);
    // Use bitwise masking to implement mux
    assign out = (a & {WIDTH{~sel}}) | (b & {WIDTH{sel}});
endmodule

module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Instantiate the parameterized 100-bit wide mux with bitwise logic
    Mux2to1_Nbit #(.WIDTH(100)) u_mux (
        .a   (a),
        .b   (b),
        .sel (sel),
        .out (out)
    );
endmodule