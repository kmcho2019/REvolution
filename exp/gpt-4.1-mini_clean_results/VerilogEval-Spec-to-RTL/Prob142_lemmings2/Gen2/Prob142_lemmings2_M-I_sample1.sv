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

    // State encoding
    typedef enum reg [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10
    } state_t;

    reg [1:0] state, next_state;

    // Walking direction: 0 = left, 1 = right
    reg walking_dir;

    // Register to hold previous ground for edge detection (synchronous)
    reg ground_d;

    // Synchronous edge detection signals
    wire ground_falling_edge = (ground_d == 1'b1) && (ground == 1'b0);
    wire ground_rising_edge  = (ground_d == 1'b0) && (ground == 1'b1);

    // State and walking_dir update logic, synchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state       <= WALK_LEFT;
            walking_dir <= 1'b0;  // left
            ground_d    <= 1'b1;  // assume ground initially present
        end else begin
            ground_d <= ground;

            state <= next_state;

            // Update walking_dir only when walking and ground stable (no edge)
            // walking_dir stays during FALLING and edges
            if ((state == WALK_LEFT || state == WALK_RIGHT) && 
                !ground_falling_edge && !ground_rising_edge && ground) begin
                // Check bumps only when ground stable and walking
                if (bump_left || bump_right) begin
                    walking_dir <= ~walking_dir;
                end
                // else walking_dir unchanged
            end
            // else walking_dir unchanged (falling or ground edge)
        end
    end

    // Next state combinational logic
    always @(*) begin
        // Default hold current state
        next_state = state;

        case(state)
            WALK_LEFT, WALK_RIGHT: begin
                if (ground_falling_edge || (ground == 1'b0)) begin
                    // Start falling on ground loss or falling edge
                    next_state = FALLING;
                end else begin
                    // Ground stable and walking, remain walking in walking_dir
                    // walking_dir changes handled separately
                    if (walking_dir == 1'b0)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                end
            end
            FALLING: begin
                if (ground_rising_edge || ground == 1'b1) begin
                    // Resume walking on ground rise or ground stable
                    if (walking_dir == 1'b0)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                end else begin
                    next_state = FALLING;
                end
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // Moore outputs based on state
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