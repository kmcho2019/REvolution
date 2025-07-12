module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Define states
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALLING = 2'b10;

// Internal state register
reg [1:0] state;
reg [1:0] next_state;

// Output logic
always @(*) begin
    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
    endcase
end

// Next state logic
always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (!ground) begin
                next_state = FALLING;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (!ground) begin
                next_state = FALLING;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (state == FALLING) begin
                    // Preserving previous direction
                    if (bump_left || bump_right) begin
                        if (next_state == WALK_LEFT) begin
                            next_state = WALK_RIGHT;
                        end else begin
                            next_state = WALK_LEFT;
                        end
                    end else begin
                        next_state = WALK_LEFT; // Preserving previous direction
                    end
                end else begin
                    next_state = WALK_LEFT; // Initial direction after reset
                end
            end else begin
                next_state = FALLING;
            end
        end
        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

endmodule