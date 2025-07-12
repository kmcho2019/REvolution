module TopModule(
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output walk_left,
  output walk_right
);

parameter WALK_LEFT = 0, WALK_RIGHT = 1;
reg [0:0] state;
reg [0:0] next_state;

always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= WALK_LEFT;
  end else begin
    case (state)
      WALK_LEFT: begin
        if (bump_left) begin
          state <= WALK_RIGHT;
        end else begin
          state <= WALK_LEFT;
        end
      end
      WALK_RIGHT: begin
        if (bump_right) begin
          state <= WALK_LEFT;
        end else begin
          state <= WALK_RIGHT;
        end
      end
    endcase
  end
end

always @(*) begin
  case (state)
    WALK_LEFT: begin
      walk_left <= 1;
      walk_right <= 0;
    end
    WALK_RIGHT: begin
      walk_left <= 0;
      walk_right <= 1;
    end
  endcase
end

endmodule