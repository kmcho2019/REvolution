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
parameter FALLING = 2'b10;
parameter DIGGING = 2'b11;

// Define state register
reg [1:0] state, next_state;

// Moore state machine logic
always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT; // Reset state to initial state (walking left)
    end else begin
        state <= next_state; // Update state based on next_state
    end
end

// Next state logic based on inputs and current state
always @* begin
    next_state = state;
    aaah = 0;
    digging = 0;

    case (state)
        WALK_LEFT: begin
            walk_left = 1;
            walk_right = 0;
            if (!ground) next_state = FALLING; // Lemming falls if not on the ground
            else if (dig) next_state = DIGGING; // Lemming starts digging if instructed
            else if (bump_right) next_state = WALK_RIGHT; // Lemming switches direction when bumped on the right
        end

        WALK_RIGHT: begin
            walk_left = 0;
            walk_right = 1;
            if (!ground) next_state = FALLING; // Lemming falls if not on the ground
            else if (dig) next_state = DIGGING; // Lemming starts digging if instructed
            else if (bump_left) next_state = WALK_LEFT; // Lemming switches direction when bumped on the left
        end

        FALLING: begin
            walk_left = (state == WALK_LEFT);
            walk_right = (state == WALK_RIGHT);
            aaah = 1;
            if (ground) next_state = (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT; // Lemming resumes walking in the same direction after falling
        end

        DIGGING: begin
            walk_left = (state == WALK_LEFT);
            walk_right = (state == WALK_RIGHT);
            digging = 1;
            if (!ground) next_state = FALLING; // Lemming falls after digging through the ground
        end
    endcase
end

endmodule