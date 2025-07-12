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

    // State types encoding (2 bits)
    localparam WALKING = 2'b00;
    localparam FALLING = 2'b01;
    localparam DIGGING = 2'b10;

    // Registers for state and direction
    reg [1:0] state_type, next_state_type;
    reg direction, next_direction; // 0=left, 1=right

    // Register to hold previous ground for edge detection
    reg prev_ground;

    // Asynchronous reset and sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_type <= WALKING;
            direction <= 1'b0; // walking left on reset
            prev_ground <= 1'b1; // assume starting on ground
        end else begin
            state_type <= next_state_type;
            direction <= next_direction;
            prev_ground <= ground;
        end
    end

    // Stable ground condition: ground == 1 and prev_ground == 1
    wire stable_ground = ground && prev_ground;

    // Compute bump conditions
    wire bump_both = bump_left && bump_right;
    wire bump_only_left = bump_left && !bump_right;
    wire bump_only_right = bump_right && !bump_left;
    wire bump_any = bump_left || bump_right;

    // Next state and direction combinational logic
    always @(*) begin
        // Default: hold current values
        next_state_type = state_type;
        next_direction = direction;

        case (state_type)
            WALKING: begin
                // Priority: fall > dig > bump
                if (!ground) begin
                    // Start falling immediately if no ground
                    next_state_type = FALLING;
                end else if (dig && stable_ground) begin
                    // Start digging if dig asserted and stable ground
                    next_state_type = DIGGING;
                end else if (stable_ground && bump_any) begin
                    // Handle bumps explicitly as per spec
                    if (bump_both) begin
                        next_direction = ~direction;
                    end else if (bump_only_left) begin
                        next_direction = 1'b1; // walk right
                    end else if (bump_only_right) begin
                        next_direction = 1'b0; // walk left
                    end
                    // remain walking
                end
                // else remain walking with current direction
            end

            FALLING: begin
                // Remain falling until ground returns
                if (ground) begin
                    next_state_type = WALKING;
                end
                // Direction unchanged
            end

            DIGGING: begin
                // Continue digging while on ground
                if (!ground) begin
                    // Start falling if ground disappears
                    next_state_type = FALLING;
                end
                // Direction unchanged
            end

            default: begin
                // Safety fallback to walking left
                next_state_type = WALKING;
                next_direction = 1'b0;
            end
        endcase
    end

    // Output signals (Moore FSM outputs)
    assign walk_left  = (state_type == WALKING) && (direction == 1'b0);
    assign walk_right = (state_type == WALKING) && (direction == 1'b1);
    assign aaah       = (state_type == FALLING);
    assign digging    = (state_type == DIGGING);

endmodule