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
parameter LEFT = 2'b00;
parameter RIGHT = 2'b01;
parameter FALLING = 2'b10;

// State register
reg [1:0] state, next_state;

// Next state logic
always @(*) begin
    case(state)
        LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = RIGHT;
            end else begin
                next_state = LEFT;
            end
        end
        RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (bump_right) begin
                next_state = LEFT;
            end else begin
                next_state = RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (bump_left || bump_right) begin
                    next_state = state; // Do not switch direction
                end else begin
                    next_state = LEFT; // Default to LEFT
                end
            end else begin
                next_state = FALLING;
            end
        end
    endcase
end

// Output logic
always @(*) begin
    case(state)
        LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
    endcase
end

// State register update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
    end else begin
        state <= next_state;
    end
end

endmodule