module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  input dig,
  output reg walk_left,
  output reg walk_right,
  output reg aaah,
  output reg digging
);

typedef enum {WALK_LEFT, WALK_RIGHT, FALL, DIGGING} state_t;
reg [1:0] state, next_state;

always @(posedge clk or posedge areset) begin
  if (areset == 1) begin
    state <= WALK_LEFT;
  end else begin
    state <= next_state;
  end
end

always @* begin
  walk_left = 0;
  walk_right = 0;
  aaah = 0;
  digging = 0;

  case (state)
    WALK_LEFT: begin
      if (bump_left && !bump_right) begin
        next_state = WALK_RIGHT;
      end else if (!ground) begin
        next_state = FALL;
      end else if (dig && ground) begin
        next_state = DIGGING;
      end
      walk_left = 1;
    end
    WALK_RIGHT: begin
      if (!bump_left && bump_right) begin
        next_state = WALK_LEFT;
      end else if (!ground) begin
        next_state = FALL;
      end else if (dig && ground) begin
        next_state = DIGGING;
      end
      walk_right = 1;
    end
    FALL: begin
      if (ground) begin
        next_state = walk_left ? WALK_LEFT : WALK_RIGHT;
      end else begin
        aaah = 1;
      end
    end
    DIGGING: begin
      digging = 1;
      if (!ground) begin
        next_state = FALL;
      end
    end
  endcase
end

endmodule