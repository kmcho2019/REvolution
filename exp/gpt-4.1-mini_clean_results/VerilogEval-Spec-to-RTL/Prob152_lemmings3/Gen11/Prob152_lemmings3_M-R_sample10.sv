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

    // State encoding: bits[2:1] = mode, bit[0] = dir
    // mode: 00 = WALK, 01 = FALL, 10 = DIG
    // dir:  0 = left, 1 = right
    localparam MODE_WALK = 2'b00,
               MODE_FALL = 2'b01,
               MODE_DIG  = 2'b10;

    reg [2:0] state, next_state;

    wire [1:0] mode = state[2:1];
    wire dir = state[0];

    // Combinational next-state logic
    always @(*) begin
        next_state = state; // default hold

        case (mode)
            MODE_WALK: begin
                if (!ground) begin
                    // Fall overrides all
                    next_state = {MODE_FALL, dir};
                end else if (dig) begin
                    // Dig if on ground and dig=1
                    next_state = {MODE_DIG, dir};
                end else if (bump_left || bump_right) begin
                    // Switch direction on bump
                    if (bump_left && bump_right)
                        next_state = {MODE_WALK, ~dir};
                    else if (bump_left)
                        next_state = {MODE_WALK, 1'b1};
                    else // bump_right
                        next_state = {MODE_WALK, 1'b0};
                end
            end

            MODE_FALL: begin
                if (ground) begin
                    // Resume walking after fall
                    next_state = {MODE_WALK, dir};
                end
                // else remain falling
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Start falling when no ground during dig
                    next_state = {MODE_FALL, dir};
                end
                // else keep digging
            end

            default: next_state = {MODE_WALK, 1'b0}; // safe fallback
        endcase
    end

    // Sequential state update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= {MODE_WALK, 1'b0}; // walk left on reset
        end else begin
            state <= next_state;
        end
    end

    assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule