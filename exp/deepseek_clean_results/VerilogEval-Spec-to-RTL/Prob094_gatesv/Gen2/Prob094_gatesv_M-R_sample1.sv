module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both[2:0] = in[3:1] AND in[2:0] (out_both[3] is don't-care)
    assign out_both[0] = in[1] & in[0];
    assign out_both[1] = in[2] & in[1];
    assign out_both[2] = in[3] & in[2];

    // out_any[3:1] = in[3:1] OR in[2:0] (out_any[0] is don't-care)
    assign out_any[1] = in[1] | in[0];
    assign out_any[2] = in[2] | in[1];
    assign out_any[3] = in[3] | in[2];

    // out_different = in XOR left-rotated in (wrap-around comparison)
    assign out_different[0] = in[0] ^ in[3];
    assign out_different[1] = in[1] ^ in[0];
    assign out_different[2] = in[2] ^ in[1];
    assign out_different[3] = in[3] ^ in[2];

endmodule