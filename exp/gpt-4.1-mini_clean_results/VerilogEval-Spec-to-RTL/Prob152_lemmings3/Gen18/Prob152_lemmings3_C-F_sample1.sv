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

    // State encoding: [2] = mode bits, [1:0] encode mode and direction as follows:
    // We encode mode in bits [2:1], direction in bit [0]:
    // Modes (2 bits): 00 = WALK, 01 = FALL, 10 = DIG
    // Direction (1 bit): 0 = left, 1 = right
    // Full state: {mode[1:0], dir}
    // We use 3 bits total:
    // bit 2 - mode high bit
    // bit 1 - mode low bit
    // bit 0 - dir
    // Encoding:
    // WALK (00): 2'b00, dir=0/1 -> 3'b000 or 3'b001
    // FALL (01): 2'b01, dir=0/1 -> 3'b010 or 3'b011
    // DIG  (10): 2'b10, dir=0/1 -> 3'b100 or 3'b101

    localparam [2:0]
        WALK_LEFT  = 3'b000,
        WALK_RIGHT = 3'b001,
        FALL_LEFT  = 3'b010,
        FALL_RIGHT = 3'b011,
        DIG_LEFT   = 3'b100,
        DIG_RIGHT  = 3'b101;

    reg [2:0] state, next_state;

    // Extract mode and direction from current state
    wire [1:0] mode = state[2:1];
    wire dir = state[0];

    // Next-state logic combinational block
    always @* begin
        // Default: stay in current state
        next_state = state;

        case (mode)
            2'b00: begin // WALK mode
                if (!ground) begin
                    // start falling, preserve direction
                    next_state = {2'b01, dir};
                end else if (dig) begin
                    // start digging, preserve direction
                    next_state = {2'b10, dir};
                end else begin
                    // bump direction changes
                    if (bump_left && bump_right) begin
                        // invert direction
                        next_state = {2'b00, ~dir};
                    end else if (bump_left) begin
                        // bump on left means go right
                        next_state = {2'b00, 1'b1};
                    end else if (bump_right) begin
                        // bump on right means go left
                        next_state = {2'b00, 1'b0};
                    end
                    // else no change
                end
            end

            2'b01: begin // FALL mode
                if (ground) begin
                    // stop falling, resume walking in same direction
                    next_state = {2'b00, dir};
                end
                // else remain falling, direction unchanged
            end

            2'b10: begin // DIG mode
                if (!ground) begin
                    // start falling, direction preserved
                    next_state = {2'b01, dir};
                end
                // else continue digging
            end

            default: begin
                // Should never occur; safe fallback to walking left
                next_state = WALK_LEFT;
            end
        endcase
    end

    // Sequential block: state update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;  // reset to walk left
        end else begin
            state <= next_state;
        end
    end

    // Output decoding (Moore outputs)
    assign walk_left  = (mode == 2'b00) && (dir == 1'b0);
    assign walk_right = (mode == 2'b00) && (dir == 1'b1);
    assign aaah       = (mode == 2'b01);
    assign digging    = (mode == 2'b10);

endmodule