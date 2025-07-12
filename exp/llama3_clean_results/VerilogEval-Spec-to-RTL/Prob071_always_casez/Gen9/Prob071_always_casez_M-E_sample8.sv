module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos  // 3-bit output
);

    wire [3:0] seg_or;
    wire [1:0] seg_sel;

    // Evaluate each 2-bit segment using OR gates
    or or0(in[0], in[1], seg_or[0]);
    or or1(in[2], in[3], seg_or[1]);
    or or2(in[4], in[5], seg_or[2]);
    or or3(in[6], in[7], seg_or[3]);

    // Select the segment with the first '1'
    and and0(seg_or[0], ~seg_or[1], ~seg_or[2], ~seg_or[3], seg_sel[0]);
    and and1(~seg_or[0], seg_or[1], ~seg_or[2], ~seg_or[3], seg_sel[0]);
    and and2(~seg_or[0], ~seg_or[1], seg_or[2], ~seg_or[3], seg_sel[0]);
    and and3(~seg_or[0], ~seg_or[1], ~seg_or[2], seg_or[3], seg_sel[0]);

    or or4(seg_or[0], seg_or[1], seg_sel[1]);

    // Determine the position of the first '1'
    assign pos[2] = seg_sel[0];
    assign pos[1] = seg_sel[1];
    assign pos[0] = (seg_sel[0] == 1'b0 && in[0]) ? 1'b0 : (seg_sel[0] == 1'b0 && in[1]) ? 1'b1 : (seg_sel[1] == 1'b0 && in[4]) ? 1'b0 : (seg_sel[1] == 1'b0 && in[5]) ? 1'b1 : (seg_sel[1] == 1'b1 && in[6]) ? 1'b0 : (seg_sel[1] == 1'b1 && in[7]) ? 1'b1 : 1'b0;

endmodule