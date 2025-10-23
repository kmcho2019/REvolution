module TopModule (
    input  clk,
    input  areset,       // async posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // One-hot states for mode+direction
    localparam WALK_L = 8'b0000_0001;
    localparam WALK_R = 8'b0000_0010;
    localparam DIG_L  = 8'b0000_0100;
    localparam DIG_R  = 8'b0000_1000;
    localparam FALL_L = 8'b0001_0000;
    localparam FALL_R = 8'b0010_0000;
    localparam SPLAT  = 8'b0100_0000;
    // Unused bit: 8'b1000_0000

    reg [7:0] state, next_state;
    reg [4:0] fall_timer, next_fall_timer;

    // Async posedge reset state and timer
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            fall_timer <= next_fall_timer;
        end
    end

    // State transitions and fall timer update
    always @(*) begin
        // Defaults hold
        next_state = state;
        next_fall_timer = 5'd0;

        // Determine falling states
        wire falling = (state == FALL_L) || (state == FALL_R);

        // Handle fall_timer
        if (falling) begin
            // Increment with saturation at 21
            if (fall_timer < 5'd21)
                next_fall_timer = fall_timer + 1'b1;
            else
                next_fall_timer = 5'd21;
        end else begin
            next_fall_timer = 5'd0;
        end

        case (state)
            WALK_L: begin
                if (!ground) begin
                    // Start falling left
                    next_state = FALL_L;
                end else if (dig) begin
                    // Start digging left
                    next_state = DIG_L;
                end else if (bump_left || bump_right) begin
                    // Switch direction to right on any bump
                    next_state = WALK_R;
                end else begin
                    next_state = WALK_L;
                end
            end

            WALK_R: begin
                if (!ground) begin
                    next_state = FALL_R;
                end else if (dig) begin
                    next_state = DIG_R;
                end else if (bump_left || bump_right) begin
                    // Switch direction to left on any bump
                    next_state = WALK_L;
                end else begin
                    next_state = WALK_R;
                end
            end

            DIG_L: begin
                if (!ground) begin
                    // Fall after digging left
                    next_state = FALL_L;
                end else begin
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

            FALL_L: begin
                if (ground) begin
                    // Landed left
                    if (fall_timer > 5'd20)
                        next_state = SPLAT;
                    else
                        next_state = WALK_L;
                end else begin
                    next_state = FALL_L;
                end
            end

            FALL_R: begin
                if (ground) begin
                    if (fall_timer > 5'd20)
                        next_state = SPLAT;
                    else
                        next_state = WALK_R;
                end else begin
                    next_state = FALL_R;
                end
            end

            SPLAT: begin
                // Forever splattered
                next_state = SPLAT;
            end

            default: begin
                // On unknown state, reset to walk left
                next_state = WALK_L;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Outputs based on Moore encoding of state
    assign walk_left  = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign digging    = (state == DIG_L) || (state == DIG_R);
    assign aaah       = (state == FALL_L) || (state == FALL_R);

endmodule