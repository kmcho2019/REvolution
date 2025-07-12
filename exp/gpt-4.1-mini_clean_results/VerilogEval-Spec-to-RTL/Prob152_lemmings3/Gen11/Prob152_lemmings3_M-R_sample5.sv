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

reg [2:0] state;        // [2:1] = mode, [0] = dir (0=left, 1=right)
reg [2:0] next_state;

wire [1:0] mode = state[2:1];
wire dir = state[0];

always @* begin
    next_state = state; // default no change

    case (mode)
        MODE_WALK: begin
            if (!ground) begin
                // Ground gone: start falling, preserve direction
                next_state = {MODE_FALL, dir};
            end else if (dig) begin
                // Start digging if requested and on ground
                next_state = {MODE_DIG, dir};
            end else if (bump_left || bump_right) begin
                // Bumped: switch directions
                // If bumped on both sides, toggle direction
                if (bump_left && bump_right)
                    next_state = {MODE_WALK, ~dir};
                else if (bump_left)
                    next_state = {MODE_WALK, 1'b1}; // walk right
                else // bump_right only
                    next_state = {MODE_WALK, 1'b0}; // walk left
            end
        end
        MODE_FALL: begin
            if (ground) begin
                // Landed: resume walking in same direction
                next_state = {MODE_WALK, dir};
            end
        end
        MODE_DIG: begin
            if (!ground) begin
                // Digging reached ground edge, start falling
                next_state = {MODE_FALL, dir};
            end
        end
        default: begin
            // Safe default to walking left
            next_state = {MODE_WALK, 1'b0};
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= {MODE_WALK, 1'b0}; // reset to walk left
    else
        state <= next_state;
end

assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule