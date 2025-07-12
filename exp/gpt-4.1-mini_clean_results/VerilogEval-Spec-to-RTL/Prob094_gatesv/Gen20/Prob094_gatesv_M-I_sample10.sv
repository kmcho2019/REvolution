module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // Define zero constant for bits with no neighbors to reduce toggling
    localparam zero_bit = 1'b0;

    // out_both[i] = in[i] & in[i+1] for i=0..2; out_both[3] = 0 (no left neighbor)
    assign out_both[0] = in[0] & in[1];
    assign out_both[1] = in[1] & in[2];
    assign out_both[2] = in[2] & in[3];
    assign out_both[3] = zero_bit;

    // out_any[i] = in[i] | in[i-1] for i=1..3; out_any[0] = 0 (no right neighbor)
    assign out_any[0] = zero_bit;
    assign out_any[1] = in[1] | in[0];
    assign out_any[2] = in[2] | in[1];
    assign out_any[3] = in[3] | in[2];

    // out_different[i] = in[i] ^ in[left neighbor], with wrap-around
    // left neighbor for in[3] is in[0], implemented with concatenation
    assign out_different = in ^ {in[0], in[3], in[2], in[1]};

endmodule