module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    // State encoding: 2 bits
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALLING    = 2'b10;

    reg [1:0] state, next_state;
    reg ground_d; // delayed ground for edge detection

    wire ground_falling_edge = (ground_d == 1'b1) && (ground == 1'b0);
    wire ground_rising_edge  = (ground_d == 1'b0) && (ground == 1'b1);

    // Next state combinational logic depends on current state, bumps, and ground edges
    always @(*) begin
        next_state = state;

        case(state)
            WALK_LEFT, WALK_RIGHT: begin
                if (ground_falling_edge || (ground == 1'b0)) begin
                    next_state = FALLING;
                end else begin
                    // walking: change direction immediately on bump
                    if (bump_left || bump_right) begin
                        if (state == WALK_LEFT)
                            next_state = WALK_RIGHT;
                        else
                            next_state = WALK_LEFT;
                    end else begin
                        next_state = state;
                    end
                end
            end
            FALLING: begin
                if (ground_rising_edge || (ground == 1'b1)) begin
                    // resume walking in same direction as before fall
                    // preserve direction by going to previous walking state
                    // but since state holds only FALLING, need to store direction before
                    // We'll store direction in a reg walking_dir_reg updated when walking.
                    // For simplicity here, on rising edge go to WALK_LEFT by default.
                    // We'll fix that in sequential logic.
                    next_state = state; // placeholder, updated in sequential block
                end else begin
                    next_state = FALLING;
                end
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    reg walking_dir_reg; // 0=left,1=right; stores walking direction when not falling

    // Sequential logic: update state, ground_d, and walking_dir_reg
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state          <= WALK_LEFT;
            walking_dir_reg <= 1'b0;
            ground_d       <= 1'b1; // assume ground present at reset
        end else begin
            ground_d <= ground;

            // Handle FALLING state resume transition here to pick correct walking_dir
            if (state == FALLING) begin
                if (ground_rising_edge || (ground == 1'b1)) begin
                    // Resume walking in stored direction
                    state <= (walking_dir_reg == 1'b0) ? WALK_LEFT : WALK_RIGHT;
                end else begin
                    state <= FALLING;
                end
                // walking_dir_reg unchanged during falling
            end else begin
                // Not falling: update state normally with bumps and ground edges
                if (ground_falling_edge || (ground == 1'b0)) begin
                    state <= FALLING;
                    // keep walking_dir_reg unchanged on fall
                end else if (bump_left || bump_right) begin
                    // Flip direction immediately on bump
                    if (state == WALK_LEFT) begin
                        state <= WALK_RIGHT;
                        walking_dir_reg <= 1'b1;
                    end else begin
                        state <= WALK_LEFT;
                        walking_dir_reg <= 1'b0;
                    end
                end else begin
                    state <= state;
                    // walking_dir_reg stays the same
                end
            end
        end
    end

    // Moore outputs based on current state
    always @(*) begin
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;

        case(state)
            WALK_LEFT:  walk_left  = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            FALLING:    aaah       = 1'b1;
            default: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
            end
        endcase
    end

endmodule