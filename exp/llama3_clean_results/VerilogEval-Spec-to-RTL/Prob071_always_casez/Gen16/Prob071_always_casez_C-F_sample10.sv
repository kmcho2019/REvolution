module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    assign pos = (~in[7] && ~in[6] && ~in[5] && ~in[4] && ~in[3] && ~in[2] && in[1] ? 3'd1 :
                  ~in[7] && ~in[6] && ~in[5] && ~in[4] && ~in[3] && in[2] ? 3'd2 :
                  ~in[7] && ~in[6] && ~in[5] && ~in[4] && in[3] ? 3'd3 :
                  ~in[7] && ~in[6] && ~in[5] && in[4] ? 3'd4 :
                  ~in[7] && ~in[6] && in[5] ? 3'd5 :
                  ~in[7] && in[6] ? 3'd6 :
                  in[7] ? 3'd7 : 
                  in[0] ? 3'd0 : 3'd0);

endmodule