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

localparam MODE_WALK = 2'b00,
           MODE_FALL = 2'b01,
           MODE_DIG  = 2'b10;

// State registers
reg [1:0] mode;
reg       dir; // 0=left, 1=right

// Next state signals
reg [1:0] next_mode;
reg       next_dir;

// Combinational next state logic
always @(*) begin
    // Default hold state
    next_mode = mode;
    next_dir  = dir;

    case (mode)
        MODE_WALK: begin
            if (!ground) begin
                // Falling overrides everything
                next_mode = MODE_FALL;
                next_dir = dir;
            end else if (dig) begin
                // Digging overrides bumps
                next_mode = MODE_DIG;
                next_dir = dir;
            end else if (bump_left || bump_right) begin
                // Switch direction on bumps when walking on ground
                if (bump_left && bump_right)
                    next_dir = ~dir;
                else if (bump_left)
                    next_dir = 1'b1; // walk right
                else // bump_right
                    next_dir = 1'b0; // walk left
                next_mode = MODE_WALK;
            end
            // else remain walking same direction
        end

        MODE_FALL: begin
            if (ground) begin
                // Resume walking in previous direction
                next_mode = MODE_WALK;
                next_dir = dir;
            end
            // else continue falling
        end

        MODE_DIG: begin
            if (!ground) begin
                // Fall when ground disappears
                next_mode = MODE_FALL;
                next_dir = dir;
            end
            // else continue digging
        end

        default: begin
            // Safety fallback to walking left
            next_mode = MODE_WALK;
            next_dir = 1'b0;
        end
    endcase
end

// Sequential update with async reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= MODE_WALK;
        dir  <= 1'b0; // walk left
    end else begin
        mode <= next_mode;
        dir  <= next_dir;
    end
end

// Outputs: Moore machine outputs depend only on current state
assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule