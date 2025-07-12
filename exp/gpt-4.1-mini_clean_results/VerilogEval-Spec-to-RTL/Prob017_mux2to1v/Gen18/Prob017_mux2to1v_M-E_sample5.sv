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
    wire [9:0] mux_out [9:0];

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : mux_chunks
            Mux2to1_10bit mux_inst (
                .a   (a[i*10 +: 10]),
                .b   (b[i*10 +: 10]),
                .sel (sel),
                .out (mux_out[i])
            );
        end
    endgenerate

    // Concatenate all chunks into final output
    assign out = {mux_out[9], mux_out[8], mux_out[7], mux_out[6], mux_out[5],
                  mux_out[4], mux_out[3], mux_out[2], mux_out[1], mux_out[0]};
endmodule