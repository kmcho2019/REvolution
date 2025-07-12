module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    reg falling;       // 1 = falling, 0 = walking
    reg direction;     // 0 = left, 1 = right

    // Combine bump inputs into a 2-bit vector for easier decoding
    wire [1:0] bump_vec = {bump_left, bump_right};

    // Next state signals
    reg next_falling;
    reg next_direction;

    always @(*) begin
        // Default to current state values
        next_falling   = falling;
        next_direction = direction;

        if (falling) begin
            // While falling
            if (ground)
                next_falling = 1'b0;  // Landed, stop falling
            // direction unchanged while falling
        end else begin
            // Not falling
            if (!ground) begin
                next_falling = 1'b1;  // Start falling
                // direction unchanged when starting to fall
            end else begin
                // On ground and walking: update direction based on bumps
                case (bump_vec)
                    2'b11: next_direction = ~direction; // both bumps: flip
                    2'b10: next_direction = 1'b1;        // bump_left: walk right
                    2'b01: next_direction = 1'b0;        // bump_right: walk left
                    default: /* no change */ ;
                endcase
            end
        end
    end

    // Sequential block with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling   <= 1'b0; // Start walking
            direction <= 1'b0; // Start walking left
        end else begin
            falling   <= next_falling;
            direction <= next_direction;
        end
    end

    // Moore outputs
    assign aaah       = falling;
    assign walk_left  = (~falling) & (direction == 1'b0);
    assign walk_right = (~falling) & (direction == 1'b1);

endmodule