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

    // Sample ground input synchronously for edge detection
    reg ground_d;

    // Ground edge flags registered synchronously
    reg ground_falling_edge;
    reg ground_rising_edge;

    // Sequential logic: state, walking_dir, ground_d, ground edge detection
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walking_dir <= 1'b0;      // walking left
            ground_d <= ground;       // sample current ground on reset
            ground_falling_edge <= 1'b0;
            ground_rising_edge <= 1'b0;
        end else begin
            state <= next_state;

            // Update ground sample and edge detection
            ground_falling_edge <= ground_d & ~ground;  // 1 when ground falls this cycle
            ground_rising_edge  <= ~ground_d & ground;  // 1 when ground rises this cycle
            ground_d <= ground;

            // Update walking_dir only when entering walking state
            if (next_state == WALK_LEFT)
                walking_dir <= 1'b0;
            else if (next_state == WALK_RIGHT)
                walking_dir <= 1'b1;
            // else keep walking_dir unchanged in FALLING
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        next_state = state; // default hold

        case(state)
            WALK_LEFT: begin
                // If ground falls or no ground, enter falling
                if (ground_falling_edge || (ground == 1'b0)) begin
                    next_state = FALLING;
                end else if (ground_rising_edge) begin
                    // Ignore bumps during ground edges
                    next_state = WALK_LEFT;
                end else begin
                    // Ground stable (ground == 1), bumps cause direction switch as:
                    // bumped on left side => switch right
                    // since walking left, bump_left triggers switch right
                    if (bump_left)
                        next_state = WALK_RIGHT;
                    else
                        next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (ground_falling_edge || (ground == 1'b0)) begin
                    next_state = FALLING;
                end else if (ground_rising_edge) begin
                    // Ignore bumps during ground edges
                    next_state = WALK_RIGHT;
                end else begin
                    // Ground stable, bumps cause direction switch as:
                    // bumped on right side => switch left
                    if (bump_right)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                end
            end

            FALLING: begin
                // Resume walking when ground rises or is stable again
                if (ground_rising_edge || (ground == 1'b1)) begin
                    if (walking_dir == 1'b0)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                end else begin
                    // still falling, ignore bumps
                    next_state = FALLING;
                end
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // Moore output logic
    always @(*) begin
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;
        case(state)
            WALK_LEFT:  walk_left  = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            FALLING:    aaah       = 1'b1;
        endcase
    end

endmodule