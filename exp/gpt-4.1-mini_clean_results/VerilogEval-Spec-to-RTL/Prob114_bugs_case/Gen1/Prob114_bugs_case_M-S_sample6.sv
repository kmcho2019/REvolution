module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output valid
);

assign {valid, out} =
    (code == 8'h45) ? {1'b1, 4'd0} :
    (code == 8'h16) ? {1'b1, 4'd1} :
    (code == 8'h1e) ? {1'b1, 4'd2} :
    (code == 8'h26) ? {1'b1, 4'd3} :
    (code == 8'h25) ? {1'b1, 4'd4} :
    (code == 8'h2e) ? {1'b1, 4'd5} :
    (code == 8'h36) ? {1'b1, 4'd6} :
    (code == 8'h3d) ? {1'b1, 4'd7} :
    (code == 8'h3e) ? {1'b1, 4'd8} :
    (code == 8'h46) ? {1'b1, 4'd9} :
                      {1'b0, 4'd0};

endmodule