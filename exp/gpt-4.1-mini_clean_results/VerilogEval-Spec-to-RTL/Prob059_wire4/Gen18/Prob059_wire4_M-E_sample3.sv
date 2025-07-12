module Demux4to4 (
    input  wire [2:0] in,      // inputs: {c,b,a}
    output wire [3:0] out      // outputs: {z, y, x, w}
);
    // out[0] = w = a
    assign out[0] = in[0];
    // out[1] = x = b
    assign out[2] = in[1];
    // out[2] = y = b
    assign out[1] = in[1];
    // out[3] = z = c
    assign out[3] = in[2];
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);
    wire [3:0] demux_out;

    Demux4to4 demux_inst (
        .in({c,b,a}),
        .out(demux_out)
    );

    assign w = demux_out[0];
    assign y = demux_out[1];
    assign x = demux_out[2];
    assign z = demux_out[3];
endmodule