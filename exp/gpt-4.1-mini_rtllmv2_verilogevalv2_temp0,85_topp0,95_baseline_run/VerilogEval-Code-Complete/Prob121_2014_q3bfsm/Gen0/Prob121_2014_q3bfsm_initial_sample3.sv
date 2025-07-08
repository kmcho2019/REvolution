module TopModule (
  input clk,
  input reset,
  input x,
  output reg z
);
  reg [2:0] state, next_state;

  // State encoding as per the table:
  // 000, 001, 010, 011, 100

  // Synchronous state register with active high reset
  always @(posedge clk) begin
    if (reset)
      state <= 3'b000;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case (state)
      3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001;
      3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100;
      3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001;
      3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010;
      3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100;
      default: next_state = 3'b000; // default to reset state for safety
    endcase
  end

  // Output logic: z = 1 only in states 011 and 100, else 0
  always @(*) begin
    case (state)
      3'b011: z = 1'b1;
      3'b100: z = 1'b1;
      default: z = 1'b0;
    endcase
  end
endmodule