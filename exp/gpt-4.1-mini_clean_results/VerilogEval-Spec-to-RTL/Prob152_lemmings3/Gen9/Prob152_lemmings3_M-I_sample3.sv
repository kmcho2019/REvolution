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

reg [2:0] state; // [2:1]=mode, [0]=dir (0=left,1=right)

// Extract mode and direction for readability
wire [1:0] mode = state[2:1];
wire dir = state[0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= {MODE_WALK, 1'b0}; // Walk left
    end else begin
        case (mode)
            MODE_WALK: begin
                if (!ground) begin
                    // Falling overrides everything
                    state <= {MODE_FALL, dir};
                end else if (dig) begin
                    // Digging if dig asserted on ground walking
                    state <= {MODE_DIG, dir};
                end else if (bump_left || bump_right) begin
                    // Change direction based on bumps:
                    // If bumped left, go right (1), else if bumped right, go left (0).
                    // If both bumps, invert direction.
                    if (bump_left && bump_right)
                        state <= {MODE_WALK, ~dir};
                    else if (bump_left)
                        state <= {MODE_WALK, 1'b1};
                    else
                        state <= {MODE_WALK, 1'b0};
                end else begin
                    // No state change
                    state <= state;
                end
            end

            MODE_FALL: begin
                if (ground) begin
                    // Resume walking same direction after falling
                    state <= {MODE_WALK, dir};
                end else begin
                    state <= state;
                end
            end

            MODE_DIG: begin
                if (!ground) begin
                    // Stop digging and start falling if no ground
                    state <= {MODE_FALL, dir};
                end else begin
                    state <= state;
                end
            end

            default: begin
                state <= {MODE_WALK, 1'b0}; // Safety fallback
            end
        endcase
    end
end

assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule