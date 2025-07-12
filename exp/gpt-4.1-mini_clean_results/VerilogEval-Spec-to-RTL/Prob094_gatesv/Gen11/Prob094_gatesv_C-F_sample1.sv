module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // out_both[i] = in[i] & in[i+1] for i=0..2; out_both[3] = 0 (no neighbor)
    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : gen_out_both
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate
    assign out_both[3] = 1'b0;

    // out_any[i] = in[i] | in[i-1] for i=1..3; out_any[0] = 0 (no neighbor)
    generate
        for (i = 1; i < 4; i = i + 1) begin : gen_out_any
            assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate
    assign out_any[0] = 1'b0;

    // out_different[i] = in[i] ^ in[(i+1)%4] using vector rotation for wrap-around
    wire [3:0] in_rotated_left;
    assign in_rotated_left = {in[2:0], in[3]}; // rotate left by 1 (left neighbor in this problem)
    assign out_different = in ^ in_rotated_left;

endmodule