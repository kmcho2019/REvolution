module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Calculate out_both
    assign out_both[0] = 1'b0; // Since there's no bit to the left of in[3]
    assign out_both[1] = in[1] & in[2];
    assign out_both[2] = in[2] & in[3];
    assign out_both[3] = 1'b0; // Since there's no bit to the left of in[3]

    // Calculate out_any
    assign out_any[0] = in[0]; // Since there's no bit to the right of in[0]
    assign out_any[1] = in[1] | in[0];
    assign out_any[2] = in[2] | in[1];
    assign out_any[3] = in[3] | in[2];

    // Calculate out_different
    assign out_different[0] = in[0] ^ in[3]; // Wrap-around for the MSB
    assign out_different[1] = in[1] ^ in[0];
    assign out_different[2] = in[2] ^ in[1];
    assign out_different[3] = in[3] ^ in[2];

endmodule