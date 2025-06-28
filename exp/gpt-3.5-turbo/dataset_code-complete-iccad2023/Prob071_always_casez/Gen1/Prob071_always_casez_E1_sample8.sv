module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

always @(*) begin
  pos = (in[0] == 1'b1) ? 3'd0 :
        (in[1] == 1'b1) ? 3'd1 :
        (in[2] == 1'b1) ? 3'd2 :
        (in[3] == 1'b1) ? 3'd3 :
        (in[4] == 1'b1) ? 3'd4 :
        (in[5] == 1'b1) ? 3'd5 :
        (in[6] == 1'b1) ? 3'd6 :
        (in[7] == 1'b1) ? 3'd7 : 3'd0; // Assign the position based on the first '1' found
end

endmodule