module TopModule (
  input clk,
  input reset,
  output reg shift_ena
);

reg [2:0] counter;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    counter <= 3'b100; // start counting to 4
    shift_ena <= 1;
  end
  else if (counter > 0) begin
    counter <= counter - 1;
  end
  else begin
    shift_ena <= 0;
  end
end

endmodule