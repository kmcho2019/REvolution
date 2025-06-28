module BCD_Counter (
  input clk, 
  input reset,
  input [2:0] ena,
  output reg [15:0] q
);

  reg [2:0] priority; // Priority encoder to determine which digit should be incremented

  always @* begin
    priority = 3'b000; // Default priority order
    if (ena[0] && !q[3:0] == 4'b1001)
      priority = 3'b001; // Increment ones digit if not '9'
    else if (ena[1] && !q[7:4] == 4'b1001)
      priority = 3'b010; // If ones digit is '9', increment tens digit
    else if (ena[2] && !q[11:8] == 4'b1001)
      priority = 3'b011; // If tens digit is '9', increment hundreds digit
  end

  always @(posedge clk) begin
    if (reset)
      q <= 16'b0; // Reset to 0000
    else begin
      case (priority)
        3'b001: // Increment ones digit
          q[3:0] <= q[3:0] + 4'b0001;
        3'b010: // Increment tens digit
          q[7:4] <= q[7:4] + 4'b0001;
        3'b011: // Increment hundreds digit
          q[11:8] <= q[11:8] + 4'b0001;
      endcase
      if (q[15:12] < 4'b1001) // Increment thousands place
        q[15:12] <= q[15:12] + 4'b0001;
      else
        q[15:12] <= 4'b0000;
    end
  end

endmodule

module TopModule (
  input clk,
  input reset,
  output [3:1] ena,
  output reg [15:0] q
);

  BCD_Counter bcd_counter (
    .clk(clk),
    .reset(reset),
    .ena(ena),
    .q(q)
  );

endmodule