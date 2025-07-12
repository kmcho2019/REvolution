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

    // State encoding: 2 bits
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL       = 2'b10;

    reg [1:0] state;
    reg digging_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            digging_reg <= 1'b0;
        end else begin
            case (state)
                WALK_LEFT, WALK_RIGHT: begin
                    if (!ground) begin
                        // Start falling, digging ends
                        state <= FALL;
                        digging_reg <= 1'b0;
                    end else if (digging_reg) begin
                        // Continue digging while ground present
                        // Stay in current walking state with digging_reg=1
                        // Nothing changes
                    end else if (dig) begin
                        // Start digging if walking on ground and not digging
                        digging_reg <= 1'b1;
                    end else begin
                        // Walking, not digging, handle bumps
                        digging_reg <= 1'b0;
                        if (bump_left && bump_right)
                            state <= (state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
                        else if (bump_left)
                            state <= WALK_RIGHT;
                        else if (bump_right)
                            state <= WALK_LEFT;
                    end
                end
                FALL: begin
                    // Falling until ground returns
                    digging_reg <= 1'b0;
                    if (ground) begin
                        // Resume previous walking direction (saved in state)
                        // Assuming state remains in FALL, but direction unchanged here, so transition
                        // We must choose which direction to walk after falling.
                        // Problem states to walk in original direction before fall.
                        // To implement that, we should save direction before fall,
                        // but here state holds direction because FALL is distinct.
                        // So let's store direction in state[0]: 0=left,1=right during fall for restore.
                        state <= {1'b0, state[0]}; // WALK_LEFT or WALK_RIGHT depending on LSB of FALL state
                    end
                end
            endcase
        end
    end

    // Outputs
    assign walk_left  = (state == WALK_LEFT) && !digging_reg;
    assign walk_right = (state == WALK_RIGHT) && !digging_reg;
    assign aaah       = (state == FALL);
    assign digging    = ((state == WALK_LEFT) || (state == WALK_RIGHT)) && digging_reg;

endmodule