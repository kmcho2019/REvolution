module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    input  wire dig,
    output reg  walk_left,
    output reg  walk_right,
    output reg  aaah,
    output reg  digging
);

// State encoding
localparam [2:0]
    WALK_LEFT    = 3'd0,
    WALK_RIGHT   = 3'd1,
    FALLING      = 3'd2,
    DIGGING_LEFT = 3'd3,
    DIGGING_RIGHT= 3'd4;

reg [2:0] state, next_state;

// Sequential state update with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= WALK_LEFT;
    else
        state <= next_state;
end

// Next state logic
always @(*) begin
    // Default next state is current state
    next_state = state;

    case(state)
        WALK_LEFT: begin
            // Priority: fall > dig > bump
            if (!ground) begin
                // fall
                next_state = FALLING;
            end else if (dig) begin
                // start digging if on ground
                next_state = DIGGING_LEFT;
            end else if (bump_left || bump_right) begin
                // bump causes direction switch
                // If bumped left or right (or both), switch direction to right
                next_state = WALK_RIGHT;
            end
        end

        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING_RIGHT;
            end else if (bump_left || bump_right) begin
                // bump causes direction switch to left
                next_state = WALK_LEFT;
            end
        end

        FALLING: begin
            // While falling, bumps and dig inputs ignored.
            // When ground reappears, resume walking in previous direction
            if (ground) begin
                // Which walking direction to resume depends on previous walking direction:
                // This is encoded by state before falling:
                // We need to remember walking direction before falling.
                // Our states WALK_LEFT and WALK_RIGHT encode walking direction.
                // When falling, we do not store previous walking direction in a separate register,
                // so we must recover it from previous state that caused falling.
                // Because states are exclusive and we don't store history explicitly,
                // we must remember walking direction by encoding in FALLING:
                // But since FALLING is one state, we can't distinguish direction here.
                // Solution: Store walking direction in a separate reg when entering FALLING.
                // We'll implement a reg walk_dir (0=left,1=right) to track walking direction.

                // We'll do this in the sequential always block below.
                // Here just check ground==1 to move to the stored walking direction state.
                // Use walk_dir reg to select state.
                // This will be done below in sequential block; for combinational next_state:
                // Use 'walk_dir' reg to select next state.

                // This assignment is deferred to below combinational block with walk_dir.
                // We implement a dummy here and override later.
                next_state = FALLING; // will be overridden
            end
        end

        DIGGING_LEFT: begin
            // While digging, bumps ignored
            // If ground disappears, start falling
            if (!ground) begin
                next_state = FALLING;
            end
            // dig=0 or 1 does not affect digging state
        end

        DIGGING_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end
        end

        default: next_state = WALK_LEFT;
    endcase
end

// We need to remember walking direction while falling so that on ground reappearance
// the Lemming resumes walking in same direction as before falling.

// Create a reg walk_dir (0=left,1=right) that tracks walking direction for use after falling.
// Update walk_dir on transitions to WALK_LEFT or DIGGING_LEFT etc.

reg walk_dir;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_dir <= 1'b0; // 0=left
    end else begin
        // Update walking direction on states indicating walking left or right or digging left or right
        case(next_state)
            WALK_LEFT,
            DIGGING_LEFT:  walk_dir <= 1'b0;
            WALK_RIGHT,
            DIGGING_RIGHT: walk_dir <= 1'b1;
            // FALLING or others: keep previous walk_dir
            default: walk_dir <= walk_dir;
        endcase
    end
end

// Now fix next_state for FALLING when ground reappears:
always @(*) begin
    // Override next_state for FALLING when ground reappears to resume walking
    if (state == FALLING && ground) begin
        if (walk_dir == 1'b0)
            next_state = WALK_LEFT;
        else
            next_state = WALK_RIGHT;
    end
end

// Outputs depend only on state (Moore machine)
always @(*) begin
    walk_left  = 1'b0;
    walk_right = 1'b0;
    aaah       = 1'b0;
    digging    = 1'b0;

    case(state)
        WALK_LEFT: begin
            walk_left = 1'b1;
        end
        WALK_RIGHT: begin
            walk_right = 1'b1;
        end
        FALLING: begin
            aaah = 1'b1;
        end
        DIGGING_LEFT: begin
            walk_left = 1'b1;
            digging   = 1'b1;
        end
        DIGGING_RIGHT: begin
            walk_right = 1'b1;
            digging    = 1'b1;
        end
        default: begin
            // default no outputs asserted
        end
    endcase
end

endmodule