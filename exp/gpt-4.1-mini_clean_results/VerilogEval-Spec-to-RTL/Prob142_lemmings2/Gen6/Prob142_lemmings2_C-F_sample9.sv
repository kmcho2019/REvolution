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

    // State registers: 1 bit each
    reg falling;       // 1 = falling, 0 = walking
    reg direction;     // 0 = left, 1 = right

    // Combine bump inputs into a 2-bit vector for concise decoding
    wire [1:0] bump_vec = {bump_left, bump_right};

    // Next state signals
    reg next_falling;
    reg next_direction;

    // Combinational logic to determine next state
    always @(*) begin
        // Default assignments preserve current state
        next_falling   = falling;
        next_direction = direction;

        if (falling) begin
            // While falling, ignore bumps; only ground restoration ends falling
            if (ground)
                next_falling = 1'b0;
            // direction unchanged while falling
        end else begin
            // Walking state
            if (!ground) begin
                // Ground lost: start falling, direction unchanged
                next_falling = 1'b1;
            end else begin
                // On ground and walking: update direction based on bumps
                case (bump_vec)
                    2'b11: next_direction = ~direction; // both bumps: flip direction
                    2'b10: next_direction = 1'b1;        // bump_left only: walk right
                    2'b01: next_direction = 1'b0;        // bump_right only: walk left
                    default: /* no change */;
                endcase
            end
        end
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling   <= 1'b0; // Start walking
            direction <= 1'b0; // Start walking left
        end else begin
            falling   <= next_falling;
            direction <= next_direction;
        end
    end

    // Moore outputs based on state registers
    assign aaah       = falling;
    assign walk_left  = (~falling) & (direction == 1'b0);
    assign walk_right = (~falling) & (direction == 1'b1);

endmodule