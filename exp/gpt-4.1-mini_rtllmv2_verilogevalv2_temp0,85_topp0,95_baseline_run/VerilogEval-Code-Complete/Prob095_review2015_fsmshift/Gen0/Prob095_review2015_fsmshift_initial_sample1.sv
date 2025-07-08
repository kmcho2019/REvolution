module TopModule (
  input clk,
  input reset,
  output shift_ena
);

  reg [1:0] count;

  always @(posedge clk) begin
    if (reset) begin
      count <= 2'd3;  // Start from 3 to get 4 cycles total (3,2,1,0)
    end else if (count != 0) begin
      count <= count - 1;
    end
  end

  assign shift_ena = (count != 0);

endmodule