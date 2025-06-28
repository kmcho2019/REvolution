module TopModule (
  input clk,
  input reset,
  input bit_pattern_detected,
  output reg shift_ena
);

reg [2:0] counter;

always @(posedge clk) begin
  if (reset) begin
    counter <= 3'd3; // Load the counter with 4 cycles when reset is asserted
    shift_ena <= 1;
  end else if (bit_pattern_detected) begin
    counter <= 3'd3; // Load the counter with 4 cycles when the proper bit pattern is detected
    shift_ena <= 1;
  end else if (counter > 0) begin
    counter <= counter - 1; // Decrement the counter
    shift_ena <= 1;
  end else begin
    shift_ena <= 0;
  end
end

endmodule