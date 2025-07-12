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

    // Mode encoding (2 bits)
    localparam MODE_WALK = 2'b00;
    localparam MODE_FALL = 2'b01;

    // State registers:
    // state[2:1]: mode (2 bits)
    // state[0]: dir (0=left,1=right)
    reg [2:0] state;
    reg digging_reg;  // 1 = digging, 0 = not digging (only valid when mode=walk)

    wire [1:0] mode = state[2:1];
    wire dir = state[0];

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset: walk left, not digging
            state <= {MODE_WALK, 1'b0};
            digging_reg <= 1'b0;
        end else begin
            case (mode)
                MODE_FALL: begin
                    // In falling mode, ignore bumps and digging.
                    // When ground returns, resume walking same dir, no digging.
                    if (ground) begin
                        state <= {MODE_WALK, dir};
                        digging_reg <= 1'b0;
                    end
                    // else remain falling
                end

                MODE_WALK: begin
                    if (!ground) begin
                        // Start falling (highest priority)
                        state <= {MODE_FALL, dir};
                        digging_reg <= 1'b0;
                    end else if (digging_reg) begin
                        // Continue digging as long as ground remains
                        // If ground disappears next cycle, handled above.
                        // No direction changes or mode changes here.
                        // digging_reg stays 1
                    end else if (dig) begin
                        // Start digging only if walking and grounded
                        digging_reg <= 1'b1;
                    end else begin
                        // Not digging, walking on ground, handle bumps
                        if (bump_left && bump_right)
                            state <= {MODE_WALK, ~dir};
                        else if (bump_left)
                            state <= {MODE_WALK, 1'b1}; // bump left -> walk right
                        else if (bump_right)
                            state <= {MODE_WALK, 1'b0}; // bump right -> walk left
                        // else no change
                    end
                end

                default: begin
                    // Defensive default: reset to walking left, no digging
                    state <= {MODE_WALK, 1'b0};
                    digging_reg <= 1'b0;
                end
            endcase
        end
    end

    // Outputs are Moore style from state and digging flag
    assign walk_left  = (mode == MODE_WALK) && (digging_reg == 1'b0) && (dir == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (digging_reg == 1'b0) && (dir == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_WALK) && (digging_reg == 1'b1);

endmodule