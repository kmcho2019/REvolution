module TopModule (
  input clk,
  input reset,
  input proper_bit_pattern,  // Assuming there is an input to detect the proper bit pattern
  output reg shift_ena
);

reg [2:0] counter;
reg state;

always @(posedge clk) begin
  if (reset) begin
    counter <= 3'b100;
    shift_ena <= 1;
    state <= 1;
  end else if (proper_bit_pattern) begin
    if (state) begin
      counter <= 3'b000;
      state <= 0;
    end else if (counter != 3'b100) begin
      counter <= counter + 1;
      shift_ena <= 1;
    end else begin
      shift_ena <= 0;
    end
  end else begin
    counter <= 3'b100;
    shift_ena <= 0;
    state <= 1;
  end
end

endmodule