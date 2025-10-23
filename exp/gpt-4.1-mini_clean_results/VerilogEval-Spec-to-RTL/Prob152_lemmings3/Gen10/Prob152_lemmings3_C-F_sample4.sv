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

    // Mode encoding in bits [2:1]
    localparam MODE_WALK = 2'b00,
               MODE_FALL = 2'b01,
               MODE_DIG  = 2'b10;

    // State register: [2:1] = mode, [0] = direction (0=left,1=right)
    reg [2:0] state, next_state;
    wire [1:0] mode = state[2:1];
    wire       dir  = state[0];

    // Combinational next state logic with clear priority and minimal conditions
    always @(*) begin
        next_state = state; // default hold

        case (mode)
            MODE_WALK: begin
                if (!ground) begin
                    // falling takes highest precedence
                    next_state = {MODE_FALL, dir};
                end else if (dig) begin
                    // dig if requested on ground and walking
                    next_state = {MODE_DIG, dir};
                end else if (bump_left && bump_right) begin
                    // both bumps invert direction
                    next_state = {MODE_WALK, ~dir};
                end else if (bump_left) begin
                    // bump left -> walk right
                    next_state = {MODE_WALK, 1'b1};
                end else if (bump_right) begin
                    // bump right -> walk left
                    next_state = {MODE_WALK, 1'b0};
                end
                // else no change
            end

            MODE_FALL: begin
                if (ground) begin
                    // land and resume walking with same dir
                    next_state = {MODE_WALK, dir};
                end
                // else keep falling
            end

            MODE_DIG: begin
                if (!ground) begin
                    // dig ends as ground disappears, start falling
                    next_state = {MODE_FALL, dir};
                end
                // else keep digging
            end

            default: begin
                // Should not happen, reset to walk left
                next_state = {MODE_WALK, 1'b0};
            end
        endcase
    end

    // Sequential state update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= {MODE_WALK, 1'b0}; // walk left on reset
        else
            state <= next_state;
    end

    // Moore outputs decoded from state bits
    assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule