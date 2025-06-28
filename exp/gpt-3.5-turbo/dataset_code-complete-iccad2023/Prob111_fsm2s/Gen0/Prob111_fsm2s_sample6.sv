module MooreStateMachine (
  input clk,
  input j,
  input k,
  input reset,
  output reg out
);

  // State definition
  typedef enum logic [1:0] {
    OFF,
    ON
  } state_type;

  // State register
  reg [1:0] state, next_state;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= OFF;
    end else begin
      state <= next_state;
    end
  end

  always @(*) begin
    // Default next state (no state change)
    next_state = state;
    
    // State transitions and output logic
    case (state)
      OFF: begin
        if (j) begin
          next_state = ON;
        end
        out = 0;
      end
      ON: begin
        if (k) begin
          next_state = OFF;
        end
        out = 1;
      end
      default: next_state = state;
    endcase
  end

endmodule