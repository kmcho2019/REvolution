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

// Define states
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALL = 2'b10;
parameter DIGGING = 2'b11;

// Define state and next state registers
reg [1:0] state, next_state;

// Moore state machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT; // Reset to initial state (walking left)
    end else begin
        state <= next_state; // Update state based on next_state
    end
end

always @* begin
    next_state = state; // Default next state is current state
    aaah = 0;
    digging = 0;

    case (state)
        WALK_LEFT: begin
            walk_left = 1;
            walk_right = 0;
            if (bump_right) next_state = WALK_RIGHT;
            else if (!ground) next_state = FALL;
            else if (dig && ground) next_state = DIGGING;
        end
        WALK_RIGHT: begin
            walk_left = 0;
            walk_right = 1;
            if (bump_left) next_state = WALK_LEFT;
            else if (!ground) next_state = FALL;
            else if (dig && ground) next_state = DIGGING;
        end
        FALL: begin
            walk_left = state == WALK_LEFT;
            walk_right = state == WALK_RIGHT;
            aaah = 1;
            if (ground) next_state = state; // Stay in same state when ground reappears
        end
        DIGGING: begin
            walk_left = state == WALK_LEFT;
            walk_right = state == WALK_RIGHT;
            digging = 1;
            if (!ground) next_state = FALL;
        end
    endcase
end

endmodule