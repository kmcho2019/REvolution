module TopModule (
  input clk,
  input reset,
  output reg shift_ena
);

reg [1:0] counter;

always @(posedge clk or posedge reset)
begin
  if (reset) begin
    counter <= 2'b00; // Initialize the counter
    shift_ena <= 1'b1; // Assert shift_ena for the first 4 cycles after reset
  end
  else begin
    if (counter < 2'b11) begin
      counter <= counter + 1;
      shift_ena <= 1'b1; // Enable shift_ena for 4 cycles after reset
    end
    else begin
      shift_ena <= 1'b0; // Disable shift_ena after 4 cycles
    end
  end
end

endmodule