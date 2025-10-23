module Mux2to1_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       sel,
    output wire [3:0] out
);
    assign out = sel ? b : a;
endmodule

module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Generate 25 instances of 4-bit muxes to cover all 100 bits
    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin : mux_blocks
            Mux2to1_4bit u_mux4 (
                .a   (a[4*i +: 4]),
                .b   (b[4*i +: 4]),
                .sel (sel),
                .out (out[4*i +: 4])
            );
        end
    endgenerate
endmodule