module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    wire [7:0] in_section1;
    wire [3:0] in_section2;
    wire [1:0] in_section3;

    assign in_section1 = in[7:0];
    assign in_section2 = in[3:0];
    assign in_section3 = in[1:0];

    assign pos = (in[7]) ? 3'd7 :
                 (in[6]) ? 3'd6 :
                 (in[5]) ? 3'd5 :
                 (in[4]) ? 3'd4 :
                 (in_section2[3] && ~in_section2[2] && ~in_section2[1] && ~in_section2[0]) ? 3'd3 :
                 (in_section2[2] && ~in_section2[1] && ~in_section2[0]) ? 3'd2 :
                 (in_section3[1] && ~in_section3[0]) ? 3'd1 :
                 (in[0]) ? 3'd0 : 3'd0;

endmodule