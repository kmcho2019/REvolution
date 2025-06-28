module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

reg [3:0] shift_register;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    shift_register <= 4'b0;
    start_shifting <= 0;
  end
  else begin
    // Shift left the register and insert the new data at the rightmost bit
    shift_register <= {shift_register[2:0], data};
    
    // Check if the sliding window matches the desired sequence 1101
    if (shift_register == 4'b1101) begin
      start_shifting <= 1; // Set shifting flag
    end
  end
end

endmodule