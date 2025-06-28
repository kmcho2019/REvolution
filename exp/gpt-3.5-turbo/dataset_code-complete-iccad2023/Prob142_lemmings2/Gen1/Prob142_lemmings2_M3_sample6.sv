module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  output reg walk_left,
  output reg walk_right,
  output reg aaah
);

  // State definition
  reg state;

  // Moore state machine
  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      state <= 1'b0; // Initial state 'LEFT' when reset
    end
    else begin
      case (state)
        1'b0: begin // LEFT state
          if (bump_right) begin
            state <= 1'b1; // Switch to RIGHT state
          end
          else if (!ground) begin
            aaah = 1'b1; // Lemming says "aaah!" when falling
          end
        end
        1'b1: begin // RIGHT state
          if (bump_left) begin
            state <= 1'b0; // Switch to LEFT state
          end
          else if (!ground) begin
            aaah = 1'b1; // Lemming says "aaah!" when falling
          end
        end
      endcase
    end
  end

  // Output assignment
  assign walk_left = (state == 1'b0) ? 1'b1 : 1'b0;
  assign walk_right = (state == 1'b1) ? 1'b1 : 1'b0;

endmodule