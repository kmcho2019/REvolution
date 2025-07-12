module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // Rotate 'in' left by 1 to get left neighbors with wrap-around
    wire [3:0] in_left = {in[2:0], in[3]};

    // Rotate 'in' right by 1 to get right neighbors with wrap-around
    wire [3:0] in_right = {in[0], in[3:1]};

    // out_both[i] = in[i] & left neighbor[i], but out_both[3] has no neighbor to left, so zero
    wire [3:0] temp_out_both = in & in_left;
    assign out_both = {1'b0, temp_out_both[2:0]}; // explicitly zero out_both[3]

    // out_any[i] = in[i] | right neighbor[i], but out_any[0] has no neighbor to right, so zero
    wire [3:0] temp_out_any = in | in_right;
    assign out_any = {temp_out_any[3:1], 1'b0}; // explicitly zero out_any[0]

    // out_different[i] = in[i] ^ left neighbor[i] with wrap-around
    assign out_different = in ^ in_left;

endmodule