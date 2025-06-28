module TopModule (
  input clk,
  input reset,
  output shift_ena
);

reg [2:0] counter;

always @(posedge clk or posedge reset)
begin
  if (reset)
    counter <= 3'b100; // set the counter to 4 when reset is asserted
  else if (counter != 3'b0)
    counter <= counter - 1; // decrement the counter if not 0
end

assign shift_ena = (counter != 3'b0);

endmodule