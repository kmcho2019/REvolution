module Mux10bit (
    input  wire [9:0] a,
    input  wire [9:0] b,
    input  wire       sel,
    output wire [9:0] out
);
    assign out = sel ? b : a;
endmodule

module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Instantiate 10 chunks of 10-bit muxes
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : chunk_mux
            Mux10bit mux_inst (
                .a   (a[10*i +: 10]),
                .b   (b[10*i +: 10]),
                .sel (sel),
                .out (out[10*i +: 10])
            );
        end
    endgenerate
endmodule