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

// Define states for the Lemming behavior
typedef enum {WALK_LEFT, WALK_RIGHT, FALLING, DIGGING_LEFT, DIGGING_RIGHT} State;
reg [2:0] current_state, next_state;

// Initialize state to walk_left upon reset
always @ (posedge areset) begin
    current_state <= WALK_LEFT;
end

// State transition and output logic
always @ (posedge clk) begin
    case (current_state)
        WALK_LEFT: begin
            if (bump_right) next_state <= WALK_LEFT;
            else if (!ground && !dig) next_state <= FALLING;
            else if (dig && ground) next_state <= DIGGING_LEFT;
            else next_state <= WALK_LEFT;
        end
        WALK_RIGHT: begin
            if (bump_left) next_state <= WALK_RIGHT;
            else if (!ground && !dig) next_state <= FALLING;
            else if (dig && ground) next_state <= DIGGING_RIGHT;
            else next_state <= WALK_RIGHT;
        end
        FALLING: begin
            if (ground) begin
                if (current_state == WALK_LEFT) next_state <= WALK_LEFT;
                else next_state <= WALK_RIGHT;
            end
            else next_state <= FALLING;
        end
        DIGGING_LEFT: begin
            if (!ground) next_state <= FALLING;
            else if (dig) next_state <= DIGGING_LEFT;
            else next_state <= WALK_LEFT;
        end
        DIGGING_RIGHT: begin
            if (!ground) next_state <= FALLING;
            else if (dig) next_state <= DIGGING_RIGHT;
            else next_state <= WALK_RIGHT;
        end
    endcase
end

// State output assignments
always @ (*) begin
    case (current_state)
        WALK_LEFT: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        WALK_RIGHT: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        FALLING: begin
            walk_left = current_state == WALK_LEFT ? 1 : 0;
            walk_right = current_state == WALK_RIGHT ? 1 : 0;
            aaah = 1;
            digging = 0;
        end
        DIGGING_LEFT: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        DIGGING_RIGHT: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 1;
        end
    endcase
end

// State transition
always @ (posedge clk) begin
    current_state <= next_state;
end

endmodule