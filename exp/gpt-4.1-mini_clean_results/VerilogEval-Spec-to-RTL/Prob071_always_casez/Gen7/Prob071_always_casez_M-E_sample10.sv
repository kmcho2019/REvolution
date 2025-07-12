module TopModule(
    input  [7:0] in,
    output [2:0] pos
);
    wire [7:0] mask = in & (~in + 1); // isolate least significant set bit
    assign pos = (mask[0]) ? 3'd0 :
                 (mask[1]) ? 3'd1 :
                 (mask[2]) ? 3'd2 :
                 (mask[3]) ? 3'd3 :
                 (mask[4]) ? 3'd4 :
                 (mask[5]) ? 3'd5 :
                 (mask[6]) ? 3'd6 :
                 (mask[7]) ? 3'd7 : 3'd0;
endmodule