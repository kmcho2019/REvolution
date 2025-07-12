module TopModule(
  input clk,
  input reset,
  input j,
  input k,
  output reg out
);

reg [0:0] state;  // Current state (0 = OFF, 1 = ON)
reg [0:0] next_state;  // Next state (0 = OFF, 1 = ON)

always @(*) begin
  case (state)
    0: begin  // Current state is OFF
      if (j == 1) begin
        next_state = 1;  // Next state is ON
      end else begin
        next_state = 0;  // Next state is OFF
      end
    end
    1: begin  // Current state is ON
      if (k == 1) begin
        next_state = 0;  // Next state is OFF
      end else begin
        next_state = 1;  // Next state is ON
      end
    end
  endcase
end

always @(posedge clk) begin
  if (reset == 1) begin
    state <= 0;  // Reset to state OFF
    out <= 0;  // Output is 0 in state OFF
  end else begin
    state <= next_state;
    if (state == 0) begin
      out <= 0;  // Output is 0 in state OFF
    end else if (state == 1) begin
      out <= 1;  // Output is 1 in state ON
    end
  end
end

endmodule