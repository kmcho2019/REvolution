module TopModule (
    input  [3:0] in,
    output [1:0] pos
);
    // Directly assign position using nested ternary operators, encoding priority from LSB to MSB
    assign pos = in[0] ? 2'd0 :
                 in[1] ? 2'd1 :
                 in[2] ? 2'd2 :
                 in[3] ? 2'd3 :
                 2'd0;  // default if none are set
endmodule