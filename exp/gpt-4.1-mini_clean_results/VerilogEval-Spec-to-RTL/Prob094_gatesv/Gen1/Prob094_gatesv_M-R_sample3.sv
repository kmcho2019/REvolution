module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);
    genvar i;

    // out_both: both current bit and left neighbor (higher index) are '1'
    // For bits 0 to 2, assign out_both[i] = in[i] & in[i+1]
    // out_both[3] = 0 as it has no left neighbor
    generate
        for (i = 0; i < 3; i = i + 1) begin : gen_out_both
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate
    assign out_both[3] = 1'b0;

    // out_any: either current bit or right neighbor (lower index) are '1'
    // For bits 1 to 3, assign out_any[i] = in[i] | in[i-1]
    // out_any[0] = 0 as it has no right neighbor
    generate
        for (i = 1; i < 4; i = i + 1) begin : gen_out_any
            assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate
    assign out_any[0] = 1'b0;

    // out_different: each bit XOR with its left neighbor (wrapping around)
    // Achieve this by XOR of 'in' with a rotated 'in' vector (left rotate by 1)
    wire [3:0] in_rotated_left = {in[2:0], in[3]};
    assign out_different = in ^ in_rotated_left;

endmodule