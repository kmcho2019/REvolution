module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // State definitions
    typedef enum logic [1:0] {
        WALK         = 2'd0,
        FALL         = 2'd1,
        FALL_TO_WALK = 2'd2
    } state_t;

    state_t state, next_state;

    // Direction definition: 0=left, 1=right
    reg direction, next_direction;

    // Asynchronous reset state and direction initialization
    // WALK and direction=left (0)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state     <= WALK;
            direction <= 1'b0; // left
        end else begin
            state     <= next_state;
            direction <= next_direction;
        end
    end

    // Next-state and next-direction combinational logic
    always @(*) begin
        // Defaults: hold current values
        next_state     = state;
        next_direction = direction;

        case (state)
            WALK: begin
                if (!ground) begin
                    // Ground lost: start falling, keep direction
                    next_state = FALL;
                    // direction unchanged
                end else begin
                    // On ground, bumps flip direction if any bump detected
                    if (bump_left | bump_right) begin
                        // Flip direction
                        next_direction = ~direction;
                        next_state = WALK;
                    end else begin
                        // No change
                        next_state = WALK;
                    end
                end
            end
            FALL: begin
                if (ground) begin
                    // Ground returned, go to transition state
                    next_state = FALL_TO_WALK;
                    // direction unchanged
                end else begin
                    // Keep falling, no direction change
                    next_state = FALL;
                end
            end
            FALL_TO_WALK: begin
                // One cycle transition to WALK after ground returns
                next_state = WALK;
                // direction unchanged
            end
            default: begin
                // Safety fallback
                next_state     = WALK;
                next_direction = 1'b0;
            end
        endcase
    end

    // Outputs are Moore type
    assign aaah       = (state == FALL) || (state == FALL_TO_WALK);
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);

endmodule