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

// Define states for the Lemming's behavior
typedef enum {WALK_LEFT, WALK_RIGHT, FALLING, DIGGING} State;
reg [1:0] current_state, next_state;

// Initialize state to walk_left upon reset
always @ (posedge areset) begin
    current_state <= WALK_LEFT;
end

// State transition and output logic
always @ (posedge clk) begin
    case (current_state)
        WALK_LEFT: begin
            if (bump_left) next_state <= WALK_RIGHT;
            else if (bump_right) next_state <= WALK_LEFT;
            else if (!ground) next_state <= FALLING;
            else if (dig) next_state <= DIGGING;
            else next_state <= WALK_LEFT;
        end
        WALK_RIGHT: begin
            if (bump_left) next_state <= WALK_RIGHT;
            else if (bump_right) next_state <= WALK_LEFT;
            else if (!ground) next_state <= FALLING;
            else if (dig) next_state <= DIGGING;
            else next_state <= WALK_RIGHT;
        end
        FALLING: begin
            if (ground) next_state <= current_state;
            else next_state <= FALLING;
        end
        DIGGING: begin
            if (!ground) next_state <= FALLING;
            else if (dig) next_state <= DIGGING;
            else next_state <= current_state;
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
        DIGGING: begin
            walk_left = 0;
            walk_right = 0;
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