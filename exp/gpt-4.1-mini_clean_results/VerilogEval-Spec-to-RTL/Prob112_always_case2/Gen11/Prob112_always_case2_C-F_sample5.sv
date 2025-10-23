module TopModule (
    input  [3:0] in,
    output [1:0] pos
);
    // Priority encoding: output position of first '1' bit from LSB to MSB
    // If none set, output zero.

    assign pos = (in[0]) ? 2'd0 :
                 (in[1]) ? 2'd1 :
                 (in[2]) ? 2'd2 :
                 (in[3]) ? 2'd3 :
                           2'd0;

endmodule