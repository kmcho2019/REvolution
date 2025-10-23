module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // State encoding
    localparam WLK_L = 3'b000; // walking left
    localparam WLK_R = 3'b001; // walking right
    localparam FALL_L= 3'b010; // falling left
    localparam FALL_R= 3'b011; // falling right
    localparam DIG_L = 3'b100; // digging left
    localparam DIG_R = 3'b101; // digging right

    reg [2:0] state, next_state;

    // Asynchronous reset and sequential state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WLK_L;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        // Default to current state
        next_state = state;

        // Helper signals
        wire bumped = bump_left | bump_right;
        // Determine current direction (left=0, right=1)
        // We only need direction info for walking/falling/digging
        // We'll use state to determine direction

        case (state)
            WLK_L: begin
                // Walking left on ground
                if (!ground) begin
                    // Ground disappeared: start falling left
                    next_state = FALL_L;
                end else if (dig) begin
                    // Start digging left on ground
                    next_state = DIG_L;
                end else if (bumped) begin
                    // Bumped: switch to walking right
                    next_state = WLK_R;
                end
                // else remain walking left
            end
            WLK_R: begin
                // Walking right on ground
                if (!ground) begin
                    next_state = FALL_R;
                end else if (dig) begin
                    next_state = DIG_R;
                end else if (bumped) begin
                    next_state = WLK_L;
                end
            end
            FALL_L: begin
                // Falling left: if ground, resume walking left
                if (ground) begin
                    next_state = WLK_L;
                end else begin
                    next_state = FALL_L;
                end
            end
            FALL_R: begin
                if (ground) begin
                    next_state = WLK_R;
                end else begin
                    next_state = FALL_R;
                end
            end
            DIG_L: begin
                // Digging left on ground
                if (!ground) begin
                    // Ground disappeared: fall left
                    next_state = FALL_L;
                end else begin
                    // Continue digging (ignoring bumps)
                    next_state = DIG_L;
                end
            end
            DIG_R: begin
                if (!ground) begin
                    next_state = FALL_R;
                end else begin
                    next_state = DIG_R;
                end
            end
            default: begin
                next_state = WLK_L;
            end
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case (state)
            WLK_L: begin
                walk_left = 1;
            end
            WLK_R: begin
                walk_right = 1;
            end
            FALL_L: begin
                aaah = 1;
            end
            FALL_R: begin
                aaah = 1;
            end
            DIG_L: begin
                digging = 1;
                walk_left = 1;
            end
            DIG_R: begin
                digging = 1;
                walk_right = 1;
            end
        endcase
    end

endmodule