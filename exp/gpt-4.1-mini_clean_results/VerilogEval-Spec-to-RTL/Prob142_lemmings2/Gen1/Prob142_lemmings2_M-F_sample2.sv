module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    // State encoding
    typedef enum reg [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10
    } state_t;

    state_t state, next_state;

    // Remember previous walking direction: 0=left, 1=right
    reg walking_dir;

    // Register to detect ground edges
    reg ground_d;

    wire ground_falling_edge = (ground_d == 1'b1) && (ground == 1'b0);
    wire ground_rising_edge  = (ground_d == 1'b0) && (ground == 1'b1);

    // Async reset and state register, update ground_d and walking_dir
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walking_dir <= 1'b0; // left
            ground_d <= 1'b1;    // assume reset with ground=1 for stable start
        end else begin
            state <= next_state;
            ground_d <= ground;

            // Update walking_dir only when in walking states
            if (next_state == WALK_LEFT)
                walking_dir <= 1'b0;
            else if (next_state == WALK_RIGHT)
                walking_dir <= 1'b1;
            // else keep walking_dir unchanged (during FALLING)
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;

        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    // Start falling immediately on ground lost
                    next_state = FALLING;
                end else if (ground_falling_edge) begin
                    // On ground falling edge, ignore bumps, start falling
                    next_state = FALLING;
                end else if (!ground_falling_edge && !ground_rising_edge) begin
                    // Ground stable at 1, handle bumps normally
                    if (bump_left || bump_right) begin
                        next_state = WALK_RIGHT;
                    end else begin
                        next_state = WALK_LEFT;
                    end
                end else begin
                    // On ground rising edge at WALK_LEFT (unlikely), ignore bumps
                    next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (ground_falling_edge) begin
                    next_state = FALLING;
                end else if (!ground_falling_edge && !ground_rising_edge) begin
                    if (bump_left || bump_right) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end else begin
                    // On ground rising edge at WALK_RIGHT, ignore bumps
                    next_state = WALK_RIGHT;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (ground_rising_edge) begin
                        // Ignore bumps during ground rising edge, resume walking_dir
                        if (walking_dir == 1'b0)
                            next_state = WALK_LEFT;
                        else
                            next_state = WALK_RIGHT;
                    end else begin
                        // Ground stable at 1 while falling - also resume walking_dir
                        if (walking_dir == 1'b0)
                            next_state = WALK_LEFT;
                        else
                            next_state = WALK_RIGHT;
                    end
                end else begin
                    // Still falling, ignore bumps
                    next_state = FALLING;
                end
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // Moore output logic
    always @(*) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        case(state)
            WALK_LEFT:  walk_left = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            FALLING:    aaah = 1'b1;
        endcase
    end

endmodule