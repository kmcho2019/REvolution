module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output [3:1] g
);

  // State encoding
  localparam A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011;

  reg [2:0] state, next_state;
  reg [2:0] device_priority;

  // FSM outputs
  assign g = (state == B) ? 3'b001 : (state == C) ? 3'b010 : (state == D) ? 3'b100 : 3'b000;

  // State flip-flop
  always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
      state <= A;
      device_priority <= 3'b000;
    end else begin
      state <= next_state;
      device_priority <= (r[1] && ~r[2] && ~r[3]) ? 3'b001 : (r[2] && ~r[1] && ~r[3]) ? 3'b010 : (r[3] && ~r[1] && ~r[2]) ? 3'b100 : device_priority;
    end
  end

  // State transitions and logic
  always @(*) begin
    case(state)
      A: begin
        if (r[1] && device_priority == 3'b001) next_state = B;
        else if (r[2] && device_priority == 3'b010) next_state = C;
        else if (r[3] && device_priority == 3'b100) next_state = D;
        else next_state = A;
      end
      B: begin
        if (r[1] && device_priority == 3'b001) next_state = B;
        else next_state = A;
      end
      C: begin
        if (r[2] && device_priority == 3'b010) next_state = C;
        else next_state = A;
      end
      D: begin
        if (r[3] && device_priority == 3'b100) next_state = D;
        else next_state = A;
      end
      default: next_state = A;
    endcase
  end

endmodule