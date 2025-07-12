module TopModule (
    input  wire [3:0] in,
    output reg  [3:0] out_both,
    output reg  [3:0] out_any,
    output reg  [3:0] out_different
);

    always @(*) begin
        // Initialize to zero to avoid latches
        out_both      = 4'b0000;
        out_any       = 4'b0000;
        out_different = 4'b0000;

        // out_both[i] = in[i] & in[i+1] for i = 0 to 2
        out_both[0] = in[0] & in[1];
        out_both[1] = in[1] & in[2];
        out_both[2] = in[2] & in[3];
        // out_both[3] = 0 (no neighbor)

        // out_any[i] = in[i] | in[i-1] for i = 1 to 3
        out_any[1] = in[1] | in[0];
        out_any[2] = in[2] | in[1];
        out_any[3] = in[3] | in[2];
        // out_any[0] = 0 (no neighbor)

        // out_different[i] = in[i] ^ in[left neighbor], with wrap-around
        out_different[0] = in[0] ^ in[3];
        out_different[1] = in[1] ^ in[0];
        out_different[2] = in[2] ^ in[1];
        out_different[3] = in[3] ^ in[2];
    end

endmodule