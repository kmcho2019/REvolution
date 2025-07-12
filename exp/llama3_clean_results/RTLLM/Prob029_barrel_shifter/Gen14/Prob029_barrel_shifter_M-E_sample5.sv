module barrel_shifter(
    input  [7:0] in,
    input  [2:0] ctrl,
    output [7:0] out
);

    // 2-to-1 multiplexer submodule
    module mux2X1(
        input  [7:0] a, b,
        input        sel,
        output [7:0] out
    );
        assign out = sel ? b : a;
    endmodule

    // 1-bit shift register submodule
    module sr_1bit(
        input  [7:0] in,
        input        shift,
        output [7:0] out
    );
        assign out = shift ? {in[6:0], in[7]} : in;
    endmodule

    // Internal signals
    wire [7:0] shift_1, shift_2, shift_4;

    // Generate shifted input bits
    sr_1bit sr_1(in, ctrl[0], shift_1);
    sr_1bit sr_2(shift_1, ctrl[1], shift_2);
    sr_1bit sr_4(shift_2, ctrl[2], shift_4);

    // Hierarchical multiplexer structure
    mux2X1 mux_1(in, shift_1, ctrl[0], out);
    mux2X1 mux_2(out, shift_2, ctrl[1], out);
    mux2X1 mux_4(out, shift_4, ctrl[2], out);

endmodule