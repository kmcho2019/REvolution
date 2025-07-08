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

// State encoding
localparam WALK_LEFT  = 2'd0;
localparam WALK_RIGHT = 2'd1;
localparam FALL       = 2'd2;
localparam DIG        = 2'd3;

reg [1:0] state, next_state;

// To remember walking direction before falling for recovery
// 0 = left, 1 = right
reg prev_dir, next_prev_dir;

// State register with asynchronous posedge reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        prev_dir <= 1'b0; // left
    end else begin
        state <= next_state;
        prev_dir <= next_prev_dir;
    end
end

// Next state logic
always @* begin
    // Default values to hold current state
    next_state = state;
    next_prev_dir = prev_dir;

    // Define bumps
    wire bumped = bump_left | bump_right;

    case(state)
        WALK_LEFT: begin
            // Precedence: fall > dig > bump
            if (!ground) begin
                // ground gone, fall
                next_state = FALL;
                next_prev_dir = 1'b0; // store walking direction left
            end else if (dig) begin
                // start digging only if on ground and walking
                next_state = DIG;
                next_prev_dir = 1'b0; // walking left
            end else if (bumped) begin
                // switch direction: bump left -> walk right; bump right -> walk left
                // if both bumped, still switch direction
                // walking left bumped means bump_left or bump_right=1, so invert direction
                next_state = WALK_RIGHT;
                next_prev_dir = 1'b1;
            end else begin
                next_state = WALK_LEFT;
                next_prev_dir = 1'b0;
            end
        end

        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALL;
                next_prev_dir = 1'b1; // walking right
            end else if (dig) begin
                next_state = DIG;
                next_prev_dir = 1'b1; // walking right
            end else if (bumped) begin
                // switch direction when bumped: bump_left or bump_right
                // walking right bumped means bump_left or bump_right=1, invert direction to left
                next_state = WALK_LEFT;
                next_prev_dir = 1'b0;
            end else begin
                next_state = WALK_RIGHT;
                next_prev_dir = 1'b1;
            end
        end

        FALL: begin
            // Falling: wait for ground=1 to recover walking direction
            if (ground) begin
                // return to walking in previous direction
                if (prev_dir == 1'b0) begin
                    next_state = WALK_LEFT;
                    next_prev_dir = 1'b0;
                end else begin
                    next_state = WALK_RIGHT;
                    next_prev_dir = 1'b1;
                end
            end else begin
                next_state = FALL;
                next_prev_dir = prev_dir; // keep prev_dir
            end
        end

        DIG: begin
            // Digging on ground
            if (!ground) begin
                // reached other side, fall now
                next_state = FALL;
                // prev_dir unchanged, stored at start of dig
                next_prev_dir = prev_dir;
            end else begin
                // keep digging as long as ground=1 and dig=1 (but no restriction on dig input to continue)
                // The problem states once digging started, it continues until ground=0
                // bump has no effect while digging
                next_state = DIG;
                next_prev_dir = prev_dir;
            end
        end

        default: begin
            // Safe default
            next_state = WALK_LEFT;
            next_prev_dir = 1'b0;
        end
    endcase
end

// Outputs (Moore machine) from current state only
always @* begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case(state)
        WALK_LEFT: begin
            walk_left = 1'b1;
        end
        WALK_RIGHT: begin
            walk_right = 1'b1;
        end
        FALL: begin
            aaah = 1'b1;
        end
        DIG: begin
            digging = 1'b1;
        end
    endcase
end

endmodule