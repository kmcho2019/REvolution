module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: each bit checks current and left neighbor (except bit 3)
    assign out_both = {
        1'b0,                    // bit 3: no left neighbor
        in[2] & in[3],           // bit 2
        in[1] & in[2],           // bit 1
        in[0] & in[1]            // bit 0
    };

    // out_any: each bit checks current or right neighbor (except bit 0)
    assign out_any = {
        in[3] | in[2],           // bit 3
        in[2] | in[1],           // bit 2
        in[1] | in[0],           // bit 1
        1'b0                     // bit 0: no right neighbor
    };

    // out_different: each bit checks against left neighbor with wrap-around
    assign out_different = {
        in[3] ^ in[0],           // bit 3 wraps to bit 0
        in[2] ^ in[3],           // bit 2
        in[1] ^ in[2],           // bit 1
        in[0] ^ in[1]            // bit 0
    };

endmodule