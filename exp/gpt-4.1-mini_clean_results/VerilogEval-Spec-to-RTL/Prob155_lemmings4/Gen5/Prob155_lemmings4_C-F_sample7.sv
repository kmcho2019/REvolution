module TopModule (
    input  clk,
    input  areset,       // asynchronous posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Mode encoding (2 bits)
    localparam [1:0]
        MODE_WALK  = 2'b00,
        MODE_FALL  = 2'b01,
        MODE_DIG   = 2'b10,
        MODE_SPLAT = 2'b11;

    // Combined state: {mode[1:0], direction[0]}
    // direction: 0=left, 1=right
    reg [2:0] state, next_state;

    wire [1:0] mode = state[2:1];
    wire       direction = state[0];

    // Fall timer: 5-bit saturating counter for fall duration
    reg [4:0] fall_timer, next_fall_timer;

    // Invert direction helper
    function automatic invert_dir(input logic d);
        invert_dir = ~d;
    endfunction

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= {MODE_WALK, 1'b0}; // walk left
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            fall_timer <= next_fall_timer;
        end
    end

    // Next state and fall timer logic
    always @(*) begin
        // Default: hold current state and timer
        next_state = state;
        next_fall_timer = fall_timer;

        case (mode)
            MODE_SPLAT: begin
                // Remain splatted forever
                next_state = {MODE_SPLAT, 1'b0};
                next_fall_timer = 5'd0;
            end

            MODE_FALL: begin
                if (!ground) begin
                    // Still falling, increment saturating at 31
                    next_state = state;
                    next_fall_timer = (fall_timer < 5'd31) ? fall_timer + 5'd1 : fall_timer;
                end else begin
                    // Landed
                    if (fall_timer > 5'd20) begin
                        // Too long falling → splatter
                        next_state = {MODE_SPLAT, 1'b0};
                        next_fall_timer = 5'd0;
                    end else begin
                        // Land safely and resume walking in same direction
                        next_state = {MODE_WALK, direction};
                        next_fall_timer = 5'd0;
                    end
                end
            end

            MODE_WALK: begin
                if (!ground) begin
                    // Start falling
                    next_state = {MODE_FALL, direction};
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    // Start digging on ground if dig=1
                    next_state = {MODE_DIG, direction};
                    next_fall_timer = 5'd0;
                end else if (bump_left || bump_right) begin
                    // Update direction according to bump inputs with explicit cases:
                    // bump_left=1 & bump_right=0 → walk right (1)
                    // bump_right=1 & bump_left=0 → walk left (0)
                    // both bump_left & bump_right=1 → toggle direction
                    if (bump_left && bump_right) begin
                        next_state = {MODE_WALK, invert_dir(direction)};
                    end else if (bump_left) begin
                        next_state = {MODE_WALK, 1'b1};
                    end else if (bump_right) begin
                        next_state = {MODE_WALK, 1'b0};
                    end else begin
                        next_state = state; // Should not occur here
                    end
                    next_fall_timer = 5'd0;
                end else begin
                    // Continue walking, no bump, no dig, ground stable
                    next_state = state;
                    next_fall_timer = 5'd0;
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Start falling from dig
                    next_state = {MODE_FALL, direction};
                    next_fall_timer = 5'd1;
                end else begin
                    // Continue digging on ground
                    next_state = state;
                    next_fall_timer = 5'd0;
                end
            end

            default: begin
                // Safe fallback reset to walk left
                next_state = {MODE_WALK, 1'b0};
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs depending only on current state and direction
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule