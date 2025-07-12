module Mux2to1_10bit (
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
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : mux_blocks
            Mux2to1_10bit u_mux (
                .a   (a[10*i +: 10]),
                .b   (b[10*i +: 10]),
                .sel (sel),
                .out (out[10*i +: 10])
            );
        end
    endgenerate
endmodule