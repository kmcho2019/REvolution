module TopModule (
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

// State encoding
localparam [1:0]
    S_WALK = 2'd0,
    S_FALL = 2'd1,
    S_DIG  = 2'd2,
    S_SPLAT= 2'd3;

reg [1:0] state, next_state;
reg dir, next_dir;           // 0=left,1=right
reg [5:0] fall_count, next_fall_count; // count fall cycles, 6 bits to avoid wrap

// Next state logic
always @* begin
    next_state = state;
    next_dir = dir;
    next_fall_count = 6'd0;

    case(state)
        S_WALK: begin
            if (!ground) begin
                // Start falling with counter 1
                next_state = S_FALL;
                next_fall_count = 6'd1;
                next_dir = dir;
            end else if (dig) begin
                // Start digging if on ground
                next_state = S_DIG;
                next_dir = dir;
            end else begin
                // Walking and bumped
                if (bump_left)
                    next_dir = 1'b1; // walk right
                else if (bump_right)
                    next_dir = 1'b0; // walk left
                next_state = S_WALK;
                next_fall_count = 6'd0;
            end
        end
        S_FALL: begin
            if (ground) begin
                // Landed: check splatter threshold
                if (fall_count > 6'd20)
                    next_state = S_SPLAT;
                else
                    next_state = S_WALK;
                next_dir = dir;
                next_fall_count = 6'd0;
            end else begin
                // Continue falling and increment fall_count
                next_state = S_FALL;
                next_dir = dir;
                next_fall_count = fall_count + 6'd1;
            end
        end
        S_DIG: begin
            if (!ground) begin
                // Fall after digging off ledge
                next_state = S_FALL;
                next_dir = dir;
                next_fall_count = 6'd1;
            end else begin
                // Continue digging
                next_state = S_DIG;
                next_dir = dir;
                next_fall_count = 6'd0;
            end
        end
        S_SPLAT: begin
            // Dead: no change
            next_state = S_SPLAT;
            next_dir = dir;
            next_fall_count = 6'd0;
        end
        default: begin
            next_state = S_WALK;
            next_dir = 1'b0;
            next_fall_count = 6'd0;
        end
    endcase
end

// Sequential update with async reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= S_WALK;
        dir <= 1'b0;       // walk left at reset
        fall_count <= 6'd0;
    end else begin
        state <= next_state;
        dir <= next_dir;
        fall_count <= next_fall_count;
    end
end

// Moore outputs
assign walk_left  = (state == S_WALK) && (dir == 1'b0);
assign walk_right = (state == S_WALK) && (dir == 1'b1);
assign aaah       = (state == S_FALL);
assign digging    = (state == S_DIG);

endmodule