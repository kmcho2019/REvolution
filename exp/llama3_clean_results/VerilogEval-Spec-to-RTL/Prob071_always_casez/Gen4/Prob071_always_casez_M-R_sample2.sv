module TopModule(
    input  [7:0] in,
    output reg [2:0] pos
);

    wire [2:0] priority_pos;

    assign priority_pos = (in[7])? 3'd7 :
                          (in[6])? 3'd6 :
                          (in[5])? 3'd5 :
                          (in[4])? 3'd4 :
                          (in[3])? 3'd3 :
                          (in[2])? 3'd2 :
                          (in[1])? 3'd1 :
                          (in[0])? 3'd0 :
                          3'd0;

    assign pos = priority_pos;

endmodule