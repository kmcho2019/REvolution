module Mux2to1_Nbit #(
    parameter WIDTH = 50
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             sel,
    output wire [WIDTH-1:0] out
);
    // Vectorized 2-to-1 mux for minimal combinational logic
    assign out = sel ? b : a;
endmodule

module TopModule(
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Partition inputs/outputs into 2 chunks of 50 bits each for reduced instance count
    Mux2to1_Nbit #(.WIDTH(50)) chunk_mux0 (
        .a   (a[49:0]),
        .b   (b[49:0]),
        .sel (sel),
        .out (out[49:0])
    );

    Mux2to1_Nbit #(.WIDTH(50)) chunk_mux1 (
        .a   (a[99:50]),
        .b   (b[99:50]),
        .sel (sel),
        .out (out[99:50])
    );
endmodule