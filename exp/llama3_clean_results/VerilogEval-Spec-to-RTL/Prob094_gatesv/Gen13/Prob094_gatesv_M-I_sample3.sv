module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    always @(*) begin
        out_both[0] = in[0] & in[1];
        out_both[1] = in[1] & in[2];
        out_both[2] = in[2] & in[3];
        out_both[3] = 1'b0; // As per requirement, no left neighbor for in[3]

        out_any[0] = in[0]; // No right neighbor for in[0]
        out_any[1] = in[1] | in[0];
        out_any[2] = in[2] | in[1];
        out_any[3] = in[3] | in[2];

        out_different[0] = in[0] ^ in[3]; // Wrap-around for in[0]
        out_different[1] = in[1] ^ in[0];
        out_different[2] = in[2] ^ in[1];
        out_different[3] = in[3] ^ in[2];
    end

endmodule