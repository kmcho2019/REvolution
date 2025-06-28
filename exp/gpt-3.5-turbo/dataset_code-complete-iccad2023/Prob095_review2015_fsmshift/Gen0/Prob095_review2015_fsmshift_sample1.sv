module TopModule (
  input clk,
  input reset,
  output shift_ena
);

reg [2:0] counter;
reg shift_ena;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    counter <= 3'b000;
    shift_ena <= 1'b1;
  end else begin
    if (counter < 3'b100 && proper_bit_pattern_detected) begin
      counter <= counter + 1;
      shift_ena <= 1'b1;
    end else begin
      counter <= 3'b0;
      shift_ena <= 1'b0;
    end
  end
end


endmodule