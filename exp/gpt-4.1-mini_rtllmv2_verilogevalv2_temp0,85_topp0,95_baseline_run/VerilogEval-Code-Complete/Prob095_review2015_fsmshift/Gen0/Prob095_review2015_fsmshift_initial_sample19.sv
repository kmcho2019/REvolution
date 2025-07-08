module TopModule (
  input clk,
  input reset,
  output shift_ena
);

  reg [1:0] count;

  // On synchronous reset, start count at 0, else increment until 3
  always @(posedge clk) begin
    if (reset)
      count <= 2'b00;
    else if (count != 2'b11)
      count <= count + 1'b1;
  end

  assign shift_ena = (count != 2'b11);

endmodule