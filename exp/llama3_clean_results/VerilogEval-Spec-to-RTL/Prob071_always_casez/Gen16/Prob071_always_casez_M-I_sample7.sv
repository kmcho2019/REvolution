module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    wire [1:0] pos_high;
    wire [1:0] pos_low;
    wire       high_group;

    // First stage: 2-bit priority encoder for each 4-bit group
    assign pos_high = (in[7] && ~in[6] && ~in[5] && ~in[4])? 2'd3 :
                      (in[6] && ~in[5] && ~in[4])? 2'd2 :
                      (in[5] && ~in[4])? 2'd1 :
                      (in[4])? 2'd0 : 2'd0;

    assign pos_low = (in[3] && ~in[2] && ~in[1] && ~in[0])? 2'd3 :
                     (in[2] && ~in[1] && ~in[0])? 2'd2 :
                     (in[1] && ~in[0])? 2'd1 :
                     (in[0])? 2'd0 : 2'd0;

    assign high_group = (in[7] || in[6] || in[5] || in[4]);

    // Second stage: 1-bit priority encoder to select the correct group
    assign pos = high_group? {1'b1, pos_high} : {1'b0, pos_low};

endmodule