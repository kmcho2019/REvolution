module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    always @(*) begin
        // out_both
        out_both[0] = 1'b0; // Since in[3] has no neighbor to the left
        out_both[1] = in[1] & in[2];
        out_both[2] = in[2] & in[3];
        out_both[3] = 1'b0; // Since in[3] has no neighbor to the left

        // out_any
        out_any[0] = in[0] | in[1]; // Since in[0] has no neighbor to the right
        out_any[1] = in[1] | in[0];
        out_any[2] = in[2] | in[1];
        out_any[3] = in[3] | in[2];

        // out_different
        out_different[0] = in[0] ^ in[3]; // Wrap-around for the first bit
        out_different[1] = in[1] ^ in[2];
        out_different[2] = in[2] ^ in[3];
        out_different[3] = in[3] ^ in[0]; // Wrap-around for the last bit
    end

endmodule