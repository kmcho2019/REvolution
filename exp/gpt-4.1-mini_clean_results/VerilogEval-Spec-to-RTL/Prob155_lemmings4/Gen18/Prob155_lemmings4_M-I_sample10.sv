module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding (3 bits: [2]fall, [1]dig, [0]dir(0=left,1=right))
    // Bits meaning:
    // bit2 = 1: FALL state (regardless of other bits)
    // bit1 = 1: DIG state (only when bit2=0)
    // bit0 = direction (0=left,1=right) for WALK or DIG
    // SPLAT is all ones: 3'b111

    // Define constants for states for clarity
    localparam WALK_LEFT  = 3'b000;
    localparam WALK_RIGHT = 3'b001;
    localparam DIG_LEFT   = 3'b010;
    localparam DIG_RIGHT  = 3'b011;
    localparam FALL_LEFT  = 3'b100;
    localparam FALL_RIGHT = 3'b101;
    localparam SPLAT      = 3'b111;

    reg [2:0] state, next_state;
    reg [4:0] fall_timer, next_fall_timer;

    wire bump = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;

    // Helper to extract direction from state
    wire dir = state[0];

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            fall_timer <= next_fall_timer;
        end
    end

    always @(*) begin
        // Defaults
        next_state = state;
        next_fall_timer = fall_timer;

        case (state)
            SPLAT: begin
                // Remain splat forever, timer zeroed
                next_state = SPLAT;
                next_fall_timer = 5'd0;
            end

            // Falling states: bit2=1
            FALL_LEFT, FALL_RIGHT: begin
                if (ground) begin
                    // Landed: splat if fallen > 20 cycles, else walk in original direction
                    if (fall_timer > 5'd20) begin
                        next_state = SPLAT;
                        next_fall_timer = 5'd0;
                    end else begin
                        // Return to WALK with stored direction bit0
                        next_state = {2'b00, state[0]};
                        next_fall_timer = 5'd0;
                    end
                end else begin
                    // Continue falling, saturate at 21
                    if (fall_timer < 5'd21)
                        next_fall_timer = fall_timer + 5'd1;
                    else
                        next_fall_timer = fall_timer;
                    // Stay in same fall state and direction
                    next_state = state;
                end
            end

            // Digging states: bit2=0, bit1=1
            DIG_LEFT, DIG_RIGHT: begin
                if (!ground) begin
                    // Ground lost, start falling in same direction
                    next_state = {1'b1, 1'b0, state[0]}; // FALL with dir
                    next_fall_timer = 5'd1;
                end else begin
                    // Continue digging
                    next_state = state;
                    next_fall_timer = 5'd0;
                end
            end

            // Walking states: bit2=0, bit1=0
            WALK_LEFT, WALK_RIGHT: begin
                if (!ground) begin
                    // Start falling in same direction
                    next_state = {1'b1, 1'b0, state[0]}; // FALL with dir
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    // Start digging, same direction
                    next_state = {1'b0, 1'b1, state[0]};
                    next_fall_timer = 5'd0;
                end else begin
                    // Walk and possibly change direction on bump
                    next_fall_timer = 5'd0;

                    if (bump_both) begin
                        // Flip direction
                        next_state = {1'b0, 1'b0, ~state[0]};
                    end else if (bump_left) begin
                        // Bumped left: walk right
                        next_state = {1'b0, 1'b0, 1'b1};
                    end else if (bump_right) begin
                        // Bumped right: walk left
                        next_state = {1'b0, 1'b0, 1'b0};
                    end else begin
                        // Keep walking same direction
                        next_state = state;
                    end
                end
            end

            default: begin
                // On invalid states, reset to walk left
                next_state = WALK_LEFT;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Outputs (Moore FSM): 
    // walk_left = walking left only (not digging or falling)
    // walk_right = walking right only
    // aaah = falling states
    // digging = digging states

    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state[2] == 1'b1) && (state != SPLAT); // falling states only
    assign digging    = (state[1] == 1'b1);

endmodule