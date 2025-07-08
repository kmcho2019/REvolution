module TopModule(
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

// State encoding
localparam WALK_LEFT  = 2'd0;
localparam WALK_RIGHT = 2'd1;
localparam FALLING    = 2'd2;
localparam DIGGING    = 2'd3;

reg [1:0] state, next_state;

// To remember direction before falling
reg dir_before_fall; // 0 = left, 1 = right

// Async reset, posedge clk FSM
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        dir_before_fall <= 1'b0; // left
    end else begin
        // Update state
        state <= next_state;
        // Update direction before fall if moving walking states
        if (next_state == WALK_LEFT)
            dir_before_fall <= 1'b0;
        else if (next_state == WALK_RIGHT)
            dir_before_fall <= 1'b1;
        // Do not update dir_before_fall in falling or digging states
    end
end

// Next state logic
always @(*) begin
    // Default next state is current state
    next_state = state;

    case(state)
        WALK_LEFT: begin
            // Priority: fall > dig > bump
            if (ground == 1'b0) begin
                next_state = FALLING;
            end else if (dig == 1'b1) begin
                // start digging only if on ground
                next_state = DIGGING;
            end else if (bump_left | bump_right) begin
                // bump switches direction
                // If bumped left or right (or both), switch direction
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_LEFT;
            end
        end

        WALK_RIGHT: begin
            if (ground == 1'b0) begin
                next_state = FALLING;
            end else if (dig == 1'b1) begin
                next_state = DIGGING;
            end else if (bump_left | bump_right) begin
                // bump switches direction
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end

        FALLING: begin
            // When ground comes back, resume walking in original direction
            if (ground == 1'b1) begin
                if (dir_before_fall == 1'b0)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end else begin
                next_state = FALLING;
            end
            // bumps and dig ignored when falling
        end

        DIGGING: begin
            // Continue digging while ground
            // When ground disappears, start falling
            if (ground == 1'b0) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
            // bumps ignored when digging
            // dig input ignored when already digging
        end

        default: begin
            next_state = WALK_LEFT; // fallback
        end
    endcase
end

// Output logic (Moore: outputs depend only on state)
always @(*) begin
    // default all outputs low
    walk_left  = 1'b0;
    walk_right = 1'b0;
    aaah       = 1'b0;
    digging    = 1'b0;

    case(state)
        WALK_LEFT:  walk_left  = 1'b1;
        WALK_RIGHT: walk_right = 1'b1;
        FALLING:    aaah       = 1'b1;
        DIGGING:    digging    = 1'b1;
    endcase
end

endmodule