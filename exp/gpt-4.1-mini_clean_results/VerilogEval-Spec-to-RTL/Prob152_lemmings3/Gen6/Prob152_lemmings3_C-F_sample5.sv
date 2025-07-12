module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Behavioral states (2 bits)
    localparam WALKING = 2'b00;
    localparam FALLING = 2'b01;
    localparam DIGGING = 2'b10;

    // Registers for state and direction
    // direction: 0=left, 1=right
    reg [1:0] state, next_state;
    reg dir, next_dir;

    // Register to hold previous ground for stable ground detection
    reg prev_ground;

    // Sequential logic: update state, direction, and prev_ground on posedge clk or async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALKING;
            dir <= 1'b0;        // start walking left
            prev_ground <= 1'b1; // assume on ground at reset
        end else begin
            state <= next_state;
            dir <= next_dir;
            prev_ground <= ground;
        end
    end

    // Detect stable ground (ground held high two consecutive cycles) to ignore bumps during transitions
    wire stable_ground = ground && prev_ground;

    // Combinational next state and next direction logic
    always @(*) begin
        // default values hold current state and dir
        next_state = state;
        next_dir = dir;

        case (state)
            WALKING: begin
                // Priority: fall > dig > bump

                if (ground == 1'b0) begin
                    // ground lost, start falling, direction unchanged
                    next_state = FALLING;
                end else if (dig && stable_ground) begin
                    // start digging if commanded and stable ground
                    next_state = DIGGING;
                end else if (stable_ground && (bump_left || bump_right)) begin
                    // bump logic: explicit direction setting
                    if (bump_left && bump_right) begin
                        // both bumps: toggle direction
                        next_dir = ~dir;
                    end else if (bump_left) begin
                        // bump on left: walk right
                        next_dir = 1'b1;
                    end else if (bump_right) begin
                        // bump on right: walk left
                        next_dir = 1'b0;
                    end
                    // remain walking
                    next_state = WALKING;
                end else begin
                    // no change
                    next_state = WALKING;
                    next_dir = dir;
                end
            end

            FALLING: begin
                // remain falling until ground returns
                if (ground == 1'b1) begin
                    // resume walking same direction
                    next_state = WALKING;
                end else begin
                    next_state = FALLING;
                end
                // direction unchanged during falling
                next_dir = dir;
            end

            DIGGING: begin
                // remain digging on ground, else fall
                if (ground == 1'b0) begin
                    next_state = FALLING;
                end else begin
                    next_state = DIGGING;
                end
                // direction unchanged during digging
                next_dir = dir;
            end

            default: begin
                // safety fallback: walk left
                next_state = WALKING;
                next_dir = 1'b0;
            end
        endcase
    end

    // Outputs reflect current state and direction (Moore)
    assign walk_left  = (state == WALKING) && (dir == 1'b0);
    assign walk_right = (state == WALKING) && (dir == 1'b1);
    assign aaah       = (state == FALLING);
    assign digging    = (state == DIGGING);

endmodule