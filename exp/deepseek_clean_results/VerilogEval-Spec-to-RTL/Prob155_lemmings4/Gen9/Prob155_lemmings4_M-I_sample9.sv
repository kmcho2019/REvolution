module TopModule (
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

    // State encoding
    parameter [2:0] WLK = 0,
                    DIG = 1,
                    FALL = 2,
                    SPLAT = 3;

    reg [2:0] state;
    reg direction;  // 0=left, 1=right
    reg [4:0] fall_counter;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WLK;
            direction <= 0;  // Start walking left
            fall_counter <= 0;
        end else begin
            case (state)
                SPLAT: ;  // Stay in splat forever

                FALL: begin
                    if (ground) begin
                        if (fall_counter > 20) begin
                            state <= SPLAT;
                        end else begin
                            state <= (digging) ? DIG : WLK;
                        end
                        fall_counter <= 0;
                    end else begin
                        fall_counter <= fall_counter + 1;
                    end
                end

                DIG: begin
                    if (~ground) begin
                        state <= FALL;
                    end
                end

                WLK: begin
                    if (~ground) begin
                        state <= FALL;
                    end else if (dig) begin
                        state <= DIG;
                    end else if (bump_left || bump_right) begin
                        // Switch direction if bumped
                        if (bump_left && ~bump_right) direction <= 1;
                        else if (bump_right && ~bump_left) direction <= 0;
                        else direction <= ~direction;  // Both bumps toggle direction
                    end
                end
            endcase
        end
    end

    // Continuous output assignments
    assign walk_left = (state == WLK) & ~direction;
    assign walk_right = (state == WLK) & direction;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule