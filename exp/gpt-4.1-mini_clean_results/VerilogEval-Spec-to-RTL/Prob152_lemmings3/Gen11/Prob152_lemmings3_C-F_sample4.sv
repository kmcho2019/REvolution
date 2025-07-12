module TopModule(
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

    // Mode encodings
    localparam MODE_WALK = 2'b00,
               MODE_FALL = 2'b01,
               MODE_DIG  = 2'b10;

    // State reg: bits[2:1] = mode, bit[0] = dir (0=left,1=right)
    reg [2:0] state, next_state;
    wire [1:0] mode = state[2:1];
    wire       dir  = state[0];

    // Combinational next state logic with priority: fall > dig > bump direction change
    always @(*) begin
        next_state = state; // default hold

        case (mode)
            MODE_WALK: begin
                if (!ground) begin
                    // Fall: enter FALL mode, keep direction
                    next_state = {MODE_FALL, dir};
                end else if (dig) begin
                    // Dig: enter DIG mode, keep direction
                    next_state = {MODE_DIG, dir};
                end else if (bump_left || bump_right) begin
                    // Switch direction on bump(s):
                    // If both bumped, invert direction.
                    // Else bump_left -> walk right (dir=1), bump_right -> walk left (dir=0)
                    if (bump_left && bump_right)
                        next_state = {MODE_WALK, ~dir};
                    else if (bump_left)
                        next_state = {MODE_WALK, 1'b1};
                    else
                        next_state = {MODE_WALK, 1'b0};
                end
                // else no change
            end

            MODE_FALL: begin
                if (ground) begin
                    // Land: resume walking with same direction
                    next_state = {MODE_WALK, dir};
                end
                // else keep falling
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Dig ends as ground disappears: fall
                    next_state = {MODE_FALL, dir};
                end
                // else keep digging
            end

            default: begin
                // Safety: unknown mode -> reset to walking left
                next_state = {MODE_WALK, 1'b0};
            end
        endcase
    end

    // Sequential logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= {MODE_WALK, 1'b0}; // Walk left on reset
        else
            state <= next_state;
    end

    // Moore outputs decoded from state bits
    assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule