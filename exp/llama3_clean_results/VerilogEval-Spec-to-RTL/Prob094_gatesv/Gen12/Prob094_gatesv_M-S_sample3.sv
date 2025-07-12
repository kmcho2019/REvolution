module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    always @(*) begin
        // out_both
        out_both[0] = 1'b0; // since there's no bit to the left of in[3]
        out_both[1] = in[1] & in[2];
        out_both[2] = in[2] & in[3];
        out_both[3] = in[3] & in[0]; // wrapping around for the most significant bit

        // out_any
        out_any[0] = in[0] | in[3]; // wrapping around for the least significant bit
        out_any[1] = in[1] | in[0];
        out_any[2] = in[2] | in[1];
        out_any[3] = 1'b0; // since there's no bit to the right of in[0]

        // out_different
        out_different[0] = in[0] ^ in[3]; // wrapping around for the least significant bit
        out_different[1] = in[1] ^ in[0];
        out_different[2] = in[2] ^ in[1];
        out_different[3] = in[3] ^ in[2];
    end

endmodule