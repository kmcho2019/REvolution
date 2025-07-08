module TopModule (
  input clk,
  input reset,
  output shift_ena
);

  reg [2:0] count;

  always @(posedge clk) begin
    if (reset)
      count <= 3'd4;        // Load 4 on reset
    else if (count != 0)
      count <= count - 1;   // Count down
  end

  assign shift_ena = (count != 0);

endmodule