module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

// Compute pos bits using priority encoding logic
// pos[0] is 1 if the first set bit's LSB position bit is 1
// pos[1] is 1 if the first set bit is in position 2 or 3
assign pos = (in[0])             ? 2'd0 :
             (in[1])             ? 2'd1 :
             (in[2])             ? 2'd2 :
             (in[3])             ? 2'd3 :
                                   2'd0;

endmodule