module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // Neighbors to the left for out_both: in[3:1] concatenated with a zero for MSB
    wire [3:0] left_neighbors = {in[3:1], 1'b0};

    // Neighbors to the right for out_any: zero concatenated with in[3:1]
    wire [3:0] right_neighbors = {1'b0, in[3:1]};

    // Rotate 'in' left by one bit for wrap-around neighbor of out_different
    wire [3:0] rotated_in = {in[2:0], in[3]};

    // out_both[i] = in[i] & in[i+1] for i=0..2; out_both[3] = 0
    assign out_both[3] = 1'b0;
    assign out_both[2] = in[2] & in[3];
    assign out_both[1] = in[1] & in[2];
    assign out_both[0] = in[0] & in[1];

    // out_any[i] = in[i] | in[i-1] for i=1..3; out_any[0] = 0
    assign out_any[0] = 1'b0;
    assign out_any[1] = in[1] | in[0];
    assign out_any[2] = in[2] | in[1];
    assign out_any[3] = in[3] | in[2];

    // out_different[i] = in[i] ^ in[(i+1) mod 4]
    assign out_different = in ^ rotated_in;

endmodule