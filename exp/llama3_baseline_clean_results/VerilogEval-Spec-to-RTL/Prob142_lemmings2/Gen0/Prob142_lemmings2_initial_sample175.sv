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

reg [1:0] state; // 2-bit state register
reg [1:0] next_state; // 2-bit next state register

// Define the states
localparam WALK_LEFT = 2'b00; // Walking left, not falling
localparam WALK_RIGHT = 2'b01; // Walking right, not falling
localparam FALL_LEFT = 2'b10; // Falling left
localparam FALL_RIGHT = 2'b11; // Falling right

// Combinational logic for next state
always @(*) begin
    case(state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALL_LEFT;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALL_RIGHT;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        FALL_LEFT: begin
            if (ground) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = FALL_LEFT;
            end
        end
        FALL_RIGHT: begin
            if (ground) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = FALL_RIGHT;
            end
        end
        default: next_state = WALK_LEFT;
    endcase
end

// Sequential logic for state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        if (bump_left && bump_right) begin
            if (state == WALK_LEFT) begin
                state <= WALK_RIGHT;
            end else if (state == WALK_RIGHT) begin
                state <= WALK_LEFT;
            end else if (state == FALL_LEFT) begin
                state <= FALL_RIGHT;
            end else if (state == FALL_RIGHT) begin
                state <= FALL_LEFT;
            end
        end else begin
            state <= next_state;
        end
    end
end

// Output logic
always @(*) begin
    case(state)
        WALK_LEFT: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
        end
        WALK_RIGHT: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
        end
        FALL_LEFT, FALL_RIGHT: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
        end
        default: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
        end
    endcase
end

endmodule