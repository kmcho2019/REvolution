module TopModule (
  input [7:0] in,
  output reg [2:0] pos
);

reg [3:0] state;

always @* begin
  case (state)
    4'b0000: begin
      if (in[0] == 1'b1)
        pos = 3;
      else if (in[1] == 1'b1)
        pos = 2;
      else if (in[2] == 1'b1)
        pos = 1;
      else if (in[3] == 1'b1)
        pos = 0;
      else
        state <= 4'b0100;
    end
    4'b0100: begin
      if (in[4] == 1'b1)
        pos = 7;
      else if (in[5] == 1'b1)
        pos = 6;
      else if (in[6] == 1'b1)
        pos = 5;
      else if (in[7] == 1'b1)
        pos = 4;
    end
  endcase
end

endmodule