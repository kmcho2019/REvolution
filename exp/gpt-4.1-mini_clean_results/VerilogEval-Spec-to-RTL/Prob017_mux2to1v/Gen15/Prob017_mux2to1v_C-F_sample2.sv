module Mux2to1_Nbit #(
    parameter WIDTH = 10
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
    // Partition inputs/outputs into 10 chunks of 10 bits each
    // Instantiate 10 chunk muxes for balanced hierarchy and synthesis efficiency
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : chunk_muxes
            Mux2to1_Nbit #(.WIDTH(10)) chunk_mux (
                .a   (a[10*i +: 10]),
                .b   (b[10*i +: 10]),
                .sel (sel),
                .out (out[10*i +: 10])
            );
        end
    endgenerate
endmodule