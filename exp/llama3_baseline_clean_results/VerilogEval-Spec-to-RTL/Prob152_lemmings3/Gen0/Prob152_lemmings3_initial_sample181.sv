module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Define the states
parameter IDLE = 2'b00;
parameter WALK_LEFT = 2'b01;
parameter WALK_RIGHT = 2'b10;
parameter FALLING = 2'b11;
parameter DIGGING_LEFT = 2'b12;
parameter DIGGING_RIGHT = 2'b13;

reg [3:0] current_state;
reg [3:0] next_state;

// Assign output signals based on the current state
always @(*)
begin
    case (current_state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        DIGGING_LEFT: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        DIGGING_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

// Determine the next state based on the current state and input signals
always @(*)
begin
    case (current_state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end
            else if (dig) begin
                next_state = DIGGING_LEFT;
            end
            else if (bump_right) begin
                next_state = WALK_RIGHT;
            end
            else if (bump_left) begin
                next_state = WALK_LEFT;
            end
            else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end
            else if (dig) begin
                next_state = DIGGING_RIGHT;
            end
            else if (bump_left) begin
                next_state = WALK_LEFT;
            end
            else if (bump_right) begin
                next_state = WALK_RIGHT;
            end
            else begin
                next_state = WALK_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (current_state == WALK_LEFT || current_state == DIGGING_LEFT) begin
                    next_state = WALK_LEFT;
                end
                else begin
                    next_state = WALK_RIGHT;
                end
            end
            else begin
                next_state = FALLING;
            end
        end
        DIGGING_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end
            else begin
                next_state = DIGGING_LEFT;
            end
        end
        DIGGING_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end
            else begin
                next_state = DIGGING_RIGHT;
            end
        end
        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

// Update the current state on the positive edge of the clock
always @(posedge clk or posedge areset)
begin
    if (areset) begin
        current_state <= WALK_LEFT;
    end
    else begin
        current_state <= next_state;
    end
end

endmodule