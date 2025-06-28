module MooreStateMachine (
  input clk,
  input j,
  input k,
  input reset,
  output reg out
);

  typedef enum logic [1:0] {
    OFF,
    ON
  } state_t;

  reg state, next_state;

  always @(posedge clk) begin
    if (reset) begin
      state <= OFF;
    end else begin
      state <= next_state;
    end
  end

  always @(state, j, k) begin
    case (state)
      OFF: begin
        if (j) begin
          next_state = ON;
        end else begin
          next_state = OFF;
        end
      end
      ON: begin
        if (k) begin
          next_state = OFF;
        end else begin
          next_state = ON;
        end
      end
    endcase
  end

  always @(state) begin
    case (state)
      OFF: out = 1'b0;
      ON: out = 1'b1;
    endcase
  end

endmodule