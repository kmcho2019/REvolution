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

    // State encoding: [2:1] = mode, [0] = direction
    localparam MODE_WALK = 2'b00;
    localparam MODE_FALL = 2'b01;
    localparam MODE_DIG  = 2'b10;

    reg [2:0] state; // {mode[1:0], dir}

    wire [1:0] mode = state[2:1];
    wire dir = state[0];

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset to walking left
            state <= {MODE_WALK, 1'b0};
        end else begin
            case (mode)
                MODE_WALK: begin
                    if (!ground) begin
                        // Highest priority: start falling
                        state <= {MODE_FALL, dir};
                    end else if (dig) begin
                        // Next priority: start digging if dig asserted and grounded
                        state <= {MODE_DIG, dir};
                    end else if (bump_left || bump_right) begin
                        // Lowest priority: switch directions on bump(s)
                        // When both bumps, invert direction
                        if (bump_left && bump_right)
                            state <= {MODE_WALK, ~dir};
                        else if (bump_left)
                            state <= {MODE_WALK, 1'b1}; // bump left => walk right
                        else // bump_right only
                            state <= {MODE_WALK, 1'b0}; // bump right => walk left
                    end
                    // else no change in state for walk with no bump, dig or fall
                end

                MODE_FALL: begin
                    if (ground) begin
                        // Resume walking same direction once ground returns
                        state <= {MODE_WALK, dir};
                    end
                    // else stay falling
                end

                MODE_DIG: begin
                    if (!ground) begin
                        // If ground disappears, start falling from digging
                        state <= {MODE_FALL, dir};
                    end
                    // else continue digging
                end

                default: begin
                    // Defensive fallback
                    state <= {MODE_WALK, 1'b0};
                end
            endcase
        end
    end

    // Outputs are combinational, from current state (Moore machine)
    assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule