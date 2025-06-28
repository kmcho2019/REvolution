module TopModule (
  input clk,
  input reset,
  input bit_pattern_detected,
  output reg shift_ena
);

reg [2:0] counter;

always @(posedge clk) begin
  if (reset) begin
    shift_ena <= 1'b0;
    counter <= 3'b0;
  end else if (bit_pattern_detected) begin
    if (counter < 3) begin
      counter <= counter + 1;
      shift_ena <= 1'b1;
    end else begin
      shift_ena <= 1'b0;
    end
  end else begin
    shift_ena <= 1'b0;
    counter <= 3'b0;
  end
end

endmodule