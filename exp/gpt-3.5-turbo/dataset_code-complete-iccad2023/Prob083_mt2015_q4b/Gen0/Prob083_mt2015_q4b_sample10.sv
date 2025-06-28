module TopModule (
  input clk,
  output reg x,
  output reg y,
  output reg z
);

reg [6:0] count;

always @(posedge clk) begin
  count <= count + 5;
  
  case(count)
    0: begin
      x <= 1;
      y <= 0;
      z <= 1;
    end
    25: begin
      x <= 0;
      y <= 0;
      z <= 1;
    end
    50: begin
      x <= 1;
      y <= 1;
      z <= 1;
    end
    55: begin
      x <= 0;
    end
    60: begin
      y <= 1;
    end
    70: begin
      z <= 1;
    end
    90: begin
      x <= 1;
      y <= 0;
      z <= 0;
    end
  endcase
end
endmodule