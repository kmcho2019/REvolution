module BCD_Counter (
  input clk,
  input reset,
  input [2:0] ena,
  output reg [15:0] q
);

reg [3:0] q_temp [0:3]; // Array to store temporary values for each BCD digit
integer i; // Loop variable for iteration

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    for (i = 0; i < 4; i = i + 1) begin
      q_temp[i] <= 4'b0000; // Reset all temporary values to 0
    end
    q <= 16'b0000; // Reset final output to 0
  end else begin
    // Increment each BCD digit conditionally based on its enable signal
    for (i = 0; i < 4; i = i + 1) begin
      if (i == 3 || (ena[i] && q_temp[i] == 4'b1001)) begin
        q_temp[i] <= 4'b0000;
      end else if (ena[i]) begin
        q_temp[i] <= q_temp[i] + 4'b0001;
      end
    end
    
    // Update the final 4-digit BCD counter by cascading the individual digits
    q <= {q_temp[3], q_temp[2], q_temp[1], q_temp[0]};
  end
end

endmodule