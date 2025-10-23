module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: current bit AND left neighbor (except MSB)
    assign out_both = {
        1'b0,                    // out_both[3] unused
        in[2] & in[3],           // out_both[2]
        in[1] & in[2],           // out_both[1]
        in[0] & in[1]            // out_both[0]
    };

    // out_any: current bit OR right neighbor (except LSB)
    assign out_any = {
        in[3] | in[2],           // out_any[3]
        in[2] | in[1],           // out_any[2]
        in[1] | in[0],           // out_any[1]
        1'b0                     // out_any[0] unused
    };

    // out_different: XOR with left neighbor (wrap-around)
    assign out_different = in ^ {in[0], in[3:1]};

endmodule