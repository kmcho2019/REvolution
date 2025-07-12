module Mux2to1_Nbit #(
    parameter WIDTH = 20
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
    // Partition inputs/outputs into 5 chunks of 20 bits each
    // Instantiate 5 chunk muxes for hierarchical clarity and synthesis efficiency
    genvar i;
    generate
        for (i = 0; i < 5; i = i + 1) begin : chunk_muxes
            Mux2to1_Nbit #(.WIDTH(20)) chunk_mux (
                .a   (a[20*i +: 20]),
                .b   (b[20*i +: 20]),
                .sel (sel),
                .out (out[20*i +: 20])
            );
        end
    endgenerate
endmodule