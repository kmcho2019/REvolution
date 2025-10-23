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

localparam MODE_WALK = 2'b00;
localparam MODE_FALL = 2'b01;
localparam MODE_DIG  = 2'b10;

reg [1:0] mode, mode_next;
reg dir, dir_next;

// Next state combinational logic
always @(*) begin
    // Default next state: hold current state
    mode_next = mode;
    dir_next  = dir;

    case (mode)
        MODE_WALK: begin
            if (!ground) begin
                // Falling overrides all else
                mode_next = MODE_FALL;
                // direction unchanged
            end else if (dig) begin
                // Start digging only if on ground and walking
                mode_next = MODE_DIG;
                // direction unchanged
            end else if (bump_left || bump_right) begin
                // Change direction if bumped, both bumps invert dir
                if (bump_left && bump_right) begin
                    dir_next = ~dir;
                end else if (bump_left) begin
                    dir_next = 1'b1; // walk right
                end else begin
                    dir_next = 1'b0; // walk left
                end
            end
            // else remain walking same dir
        end

        MODE_FALL: begin
            if (ground) begin
                // Resume walking in same dir
                mode_next = MODE_WALK;
                // dir unchanged
            end
            // else remain falling
        end

        MODE_DIG: begin
            if (!ground) begin
                // Stop digging, start falling
                mode_next = MODE_FALL;
                // dir unchanged
            end
            // else continue digging
        end

        default: begin
            mode_next = MODE_WALK;
            dir_next = 1'b0;
        end
    endcase
end

// State registers with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= MODE_WALK;
        dir  <= 1'b0; // walk left
    end else begin
        mode <= mode_next;
        dir  <= dir_next;
    end
end

// Output assignments
assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule