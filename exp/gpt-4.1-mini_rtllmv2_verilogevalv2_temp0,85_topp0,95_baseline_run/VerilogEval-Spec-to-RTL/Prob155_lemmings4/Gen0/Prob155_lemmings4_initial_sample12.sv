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

// FSM states
localparam WALK = 2'd0,
           FALL = 2'd1,
           DIG  = 2'd2,
           SPLAT= 2'd3;

// Walking direction encoding
localparam LEFT = 1'b0,
           RIGHT= 1'b1;

reg [1:0] state, next_state;
reg walking_dir, next_walking_dir;
reg [5:0] fall_counter, next_fall_counter; // 6 bits enough for >20

// Asynchronous posedge reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK;
        walking_dir <= LEFT;
        fall_counter <= 0;
    end else begin
        state <= next_state;
        walking_dir <= next_walking_dir;
        fall_counter <= next_fall_counter;
    end
end

// FSM next state logic and outputs (Moore)
always @* begin
    // Defaults
    next_state = state;
    next_walking_dir = walking_dir;
    next_fall_counter = fall_counter;

    case(state)
    WALK: begin
        next_fall_counter = 0;
        if (ground == 0) begin
            // Start falling
            next_state = FALL;
            next_fall_counter = 0;
        end else if (dig) begin
            // Start digging if on ground and walking
            next_state = DIG;
        end else if (bump_left || bump_right) begin
            // Switch direction if bumped on either side
            next_walking_dir = ~walking_dir;
        end
        // else remain walking same direction
    end

    FALL: begin
        // Increment fall counter
        next_fall_counter = fall_counter + 1;
        if (ground == 1) begin
            // Hit ground, check if splatter
            if (fall_counter > 20) begin
                next_state = SPLAT;
                // fall_counter reset not needed in splattered state
            end else begin
                next_state = WALK;
                // walking_dir remains same
                next_fall_counter = 0;
            end
        end
        // else remain falling, ignore bumps and dig
    end

    DIG: begin
        next_fall_counter = 0;
        if (ground == 0) begin
            // No ground beneath, start falling
            next_state = FALL;
            next_fall_counter = 0;
        end
        // else continue digging, bumps ignored, dig input ignored
    end

    SPLAT: begin
        // Remain splattered forever until reset
        next_fall_counter = 0;
        next_walking_dir = walking_dir; // no change
        next_state = SPLAT;
    end

    default: begin
        // should never happen, safe reset
        next_state = WALK;
        next_walking_dir = LEFT;
        next_fall_counter = 0;
    end
    endcase
end

// Outputs - Moore outputs depend only on state and walking_dir
always @* begin
    // Default all outputs zero
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case(state)
    WALK: begin
        if (walking_dir == LEFT) walk_left = 1;
        else walk_right = 1;
    end
    FALL: begin
        aaah = 1;
    end
    DIG: begin
        digging = 1;
        if (walking_dir == LEFT) walk_left = 1;
        else walk_right = 1;
    end
    SPLAT: begin
        // all outputs zero
    end
    endcase
end

endmodule