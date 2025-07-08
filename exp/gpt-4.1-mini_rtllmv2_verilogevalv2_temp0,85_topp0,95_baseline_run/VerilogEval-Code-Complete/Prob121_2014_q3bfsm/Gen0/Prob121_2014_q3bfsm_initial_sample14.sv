module TopModule (
  input clk,
  input reset,
  input x,
  output reg z
);

  reg [2:0] state, next_state;

  // Next state logic and output logic
  always @(*) begin
    case(state)
      3'b000: begin
        z = 0;
        if (x == 0)
          next_state = 3'b000;
        else
          next_state = 3'b001;
      end
      3'b001: begin
        z = 0;
        if (x == 0)
          next_state = 3'b001;
        else
          next_state = 3'b100;
      end
      3'b010: begin
        z = 0;
        if (x == 0)
          next_state = 3'b010;
        else
          next_state = 3'b001;
      end
      3'b011: begin
        z = 1;
        if (x == 0)
          next_state = 3'b001;
        else
          next_state = 3'b010;
      end
      3'b100: begin
        z = 1;
        if (x == 0)
          next_state = 3'b011;
        else
          next_state = 3'b100;
      end
      default: begin
        z = 0;
        next_state = 3'b000;
      end
    endcase
  end

  // State register with synchronous reset
  always @(posedge clk) begin
    if (reset)
      state <= 3'b000;
    else
      state <= next_state;
  end

endmodule