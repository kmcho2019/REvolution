module TopModule (
  input clk,
  input reset,
  output reg shift_ena
);

reg [2:0] counter;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    shift_ena <= 1'b0;
    counter <= 3'b0;
  end else begin
    if (counter > 0) begin
      shift_ena <= 1'b1;
      counter <= counter - 1;
    end else begin
      shift_ena <= 1'b0;
    end
  end
end

endmodule