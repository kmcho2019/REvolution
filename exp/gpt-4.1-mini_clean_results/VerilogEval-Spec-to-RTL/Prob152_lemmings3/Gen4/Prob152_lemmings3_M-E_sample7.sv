module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    input  wire dig,
    output wire walk_left,
    output wire walk_right,
    output wire aaah,
    output wire digging
);

    // State encoding
    localparam [1:0]
        S_WALK  = 2'b00,
        S_FALL  = 2'b01,
        S_DIG   = 2'b10;

    reg [1:0] state, next_state;
    reg       dir, next_dir; // 0=left, 1=right

    // Register to hold previous ground to detect edges synchronously
    reg prev_ground;

    // Combine bump signals
    wire bumped = bump_left | bump_right;

    // Sequential logic: state, direction, prev_ground update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state       <= S_WALK;
            dir         <= 1'b0;     // start walking left
            prev_ground <= 1'b1;     // assume starts on ground
        end else begin
            prev_ground <= ground;   // sample previous ground

            state <= next_state;
            dir   <= next_dir;
        end
    end

    // Combinational next state and direction logic
    always @(*) begin
        // Defaults: hold current state/direction
        next_state = state;
        next_dir   = dir;

        // Ground edges detected synchronously by comparing prev_ground and ground
        wire ground_fell = (prev_ground == 1'b1) && (ground == 1'b0);
        wire ground_rose = (prev_ground == 1'b0) && (ground == 1'b1);

        case (state)
            S_WALK: begin
                // Priority: fall > dig > bump
                if (ground_fell) begin
                    next_state = S_FALL;
                    // direction unchanged
                end else if (dig && ground) begin
                    next_state = S_DIG;
                    // direction unchanged
                end else if (bumped) begin
                    // Bumps invert direction only while walking and no ground edge happened
                    // since ground_fell handled above, no need to check here again
                    next_dir = ~dir;
                    // state remains walking
                end
            end

            S_FALL: begin
                if (ground_rose) begin
                    next_state = S_WALK;
                    // direction unchanged, resume walking in previous direction
                end
                // else remain falling, ignore bumps/dig command
            end

            S_DIG: begin
                if (!ground) begin
                    // Ground disappeared, fall now
                    next_state = S_FALL;
                    // direction unchanged
                end
                // else remain digging, ignore bumps/dig command
            end

            default: begin
                next_state = S_WALK;
                next_dir   = 1'b0; // default to walking left on unknown state
            end
        endcase
    end

    // Moore outputs derived from state and direction
    assign walk_left  = (state == S_WALK) && (dir == 1'b0);
    assign walk_right = (state == S_WALK) && (dir == 1'b1);
    assign aaah       = (state == S_FALL);
    assign digging    = (state == S_DIG);

endmodule