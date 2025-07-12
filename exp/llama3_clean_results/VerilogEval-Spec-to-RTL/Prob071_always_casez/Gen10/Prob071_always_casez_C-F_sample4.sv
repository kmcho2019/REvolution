module TopModule(
    input  [7:0] in,
    output [2:0] pos,
    input  enable
);

// Input gating to reduce switching activity
wire [7:0] in_gated;
assign in_gated = enable? in : 8'b0;

// Priority encoder implementation
assign pos = (in_gated[0]? 3'd0 :
              in_gated[1]? 3'd1 :
              in_gated[2]? 3'd2 :
              in_gated[3]? 3'd3 :
              in_gated[4]? 3'd4 :
              in_gated[5]? 3'd5 :
              in_gated[6]? 3'd6 :
              in_gated[7]? 3'd7 : 3'd0);

endmodule