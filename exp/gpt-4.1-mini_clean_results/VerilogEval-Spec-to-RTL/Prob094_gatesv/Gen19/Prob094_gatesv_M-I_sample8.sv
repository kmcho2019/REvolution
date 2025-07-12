module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // out_both[i] = in[i] & in[i+1] for i=0..2; no left neighbor for i=3, set zero
    assign out_both = {1'b0, in[2:0] & in[3:1]};

    // out_any[i] = in[i] | in[i-1] for i=1..3; no right neighbor for i=0, set zero
    assign out_any = {in[3:1] | in[2:0], 1'b0};

    // out_different[i] = in[i] ^ in[left neighbor], with wrap-around (left neighbor of 3 is 0)
    assign out_different = in ^ {in[0], in[3:1]};

endmodule