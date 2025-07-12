module TopModule (
    input [3:0] in,
    output reg [3:0] out_both,
    output reg [3:0] out_any,
    output reg [3:0] out_different
);

    always_comb begin
        // out_both: AND with left neighbor (bits 2:0 only)
        out_both[3] = 1'b0;  // No left neighbor for in[3]
        out_both[2] = in[2] & in[3];
        out_both[1] = in[1] & in[2];
        out_both[0] = in[0] & in[1];

        // out_any: OR with right neighbor (bits 3:1 only)
        out_any[3] = in[3] | in[2];
        out_any[2] = in[2] | in[1];
        out_any[1] = in[1] | in[0];
        out_any[0] = 1'b0;    // No right neighbor for in[0]

        // out_different: XOR with left neighbor (circular)
        out_different[3] = in[3] ^ in[0];
        out_different[2] = in[2] ^ in[3];
        out_different[1] = in[1] ^ in[2];
        out_different[0] = in[0] ^ in[1];
    end

endmodule