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

    // Mode encoding
    localparam MODE_WALK = 2'b00;
    localparam MODE_FALL = 2'b01;
    localparam MODE_DIG  = 2'b10;

    reg [2:0] state; // {mode[1:0], direction}

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
                        // Ground lost, start falling
                        state <= {MODE_FALL, dir};
                    end else if (dig) begin
                        // Start digging if dig command and on ground walking
                        state <= {MODE_DIG, dir};
                    end else if (bump_left || bump_right) begin
                        // Switch directions if bumped on either or both sides
                        // If both bump_left and bump_right, direction toggles
                        if (bump_left && bump_right)
                            state <= {MODE_WALK, ~dir};
                        else if (bump_left)
                            state <= {MODE_WALK, 1'b1}; // walk right
                        else // bump_right only
                            state <= {MODE_WALK, 1'b0}; // walk left
                    end
                    // else remain walking same direction
                end

                MODE_FALL: begin
                    if (ground) begin
                        // Resume walking when ground returns, direction unchanged
                        state <= {MODE_WALK, dir};
                    end
                    // else remain falling
                end

                MODE_DIG: begin
                    if (!ground) begin
                        // Start falling if ground disappears while digging
                        state <= {MODE_FALL, dir};
                    end
                    // else continue digging
                end

                default: begin
                    // Defensive fallback: reset to walk left
                    state <= {MODE_WALK, 1'b0};
                end
            endcase
        end
    end

    // Moore outputs directly from state
    assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule