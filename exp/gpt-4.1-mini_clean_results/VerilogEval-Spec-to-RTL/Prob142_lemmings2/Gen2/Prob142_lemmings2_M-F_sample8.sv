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

    // Register to detect ground edges (synchronous sampling of ground)
    reg ground_d;

    wire ground_falling_edge = ground_d & ~ground;
    wire ground_rising_edge  = ~ground_d & ground;

    // Sequential logic: state, walking_dir, ground_d
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walking_dir <= 1'b0;   // walking left
            ground_d <= ground;    // sample current ground on reset to avoid mismatch
        end else begin
            state <= next_state;
            ground_d <= ground;

            // Update walking_dir only when entering a walking state
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
                if (ground_falling_edge || (ground == 1'b0)) begin
                    // Start falling if ground falls or is lost
                    next_state = FALLING;
                end else if (ground_rising_edge) begin
                    // ground rising edge while walking: ignore bumps, stay walking
                    next_state = WALK_LEFT;
                end else begin
                    // ground stable at 1, bumps switch direction
                    if (bump_left || bump_right) 
                        next_state = WALK_RIGHT;
                    else
                        next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (ground_falling_edge || (ground == 1'b0)) begin
                    next_state = FALLING;
                end else if (ground_rising_edge) begin
                    next_state = WALK_RIGHT;
                end else begin
                    if (bump_left || bump_right)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                end
            end
            FALLING: begin
                if (ground_rising_edge || (ground == 1'b1)) begin
                    // resume walking direction when ground reappears
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