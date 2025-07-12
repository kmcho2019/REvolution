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

    // State encoding (3 bits):
    // 000: walk left
    // 001: fall left (aaah)
    // 010: dig left
    // 100: walk right
    // 101: fall right (aaah)
    // 110: dig right
    localparam WL=3'b000, FL=3'b001, DL=3'b010,
               WR=3'b100, FR=3'b101, DR=3'b110;

    reg [2:0] state, next_state;

    // Extract direction and mode from state
    // direction: 0 = left, 1 = right (state[2])
    // mode: walking=0, fall=1, dig=2
    wire direction = state[2];
    wire [1:0] mode = state[1:0];

    always @(*) begin
        next_state = state;

        if (!ground) begin
            // Fall state overrides everything; go to fall state same direction
            next_state = (direction) ? FR : FL;
        end else begin
            case(state)
                WL: begin // walking left
                    if (dig)
                        next_state = DL;
                    else if (bump_left || bump_right) begin
                        // switch to walk right on any bump
                        next_state = WR;
                    end
                    // else stay walking left
                end
                WR: begin // walking right
                    if (dig)
                        next_state = DR;
                    else if (bump_left || bump_right) begin
                        // switch to walk left on any bump
                        next_state = WL;
                    end
                    // else stay walking right
                end
                DL: begin // digging left
                    if (!ground)
                        next_state = FL; // ground lost: fall left
                    // else stay digging left
                end
                DR: begin // digging right
                    if (!ground)
                        next_state = FR; // ground lost: fall right
                    // else stay digging right
                end
                FL: begin // falling left
                    if (ground)
                        next_state = WL; // ground back: walk left
                    // else stay falling
                end
                FR: begin // falling right
                    if (ground)
                        next_state = WR; // ground back: walk right
                    // else stay falling
                end
                default: next_state = WL; // default to walk left
            endcase
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) state <= WL;
        else state <= next_state;
    end

    // Outputs
    assign walk_left  = (state == WL);
    assign walk_right = (state == WR);
    assign aaah       = (state == FL) || (state == FR);
    assign digging    = (state == DL) || (state == DR);

endmodule