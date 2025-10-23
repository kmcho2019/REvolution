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

    // One-hot state encoding
    parameter WALK = 4'b0001;
    parameter FALL = 4'b0010;
    parameter DIG  = 4'b0100;
    parameter SPLAT = 4'b1000;
    
    reg [3:0] state;
    reg direction;  // 1 = left, 0 = right
    reg [4:0] fall_timer;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b1;  // Start walking left
            fall_timer <= 0;
        end else begin
            case (1'b1)  // Synthesis will optimize this case statement
                state[0]: begin  // WALK
                    if (!ground) begin
                        state <= FALL;
                        fall_timer <= 1;
                    end else if (dig) begin
                        state <= DIG;
                    end else begin
                        // Handle direction changes only when walking
                        if (bump_left && !bump_right) direction <= 1'b0;
                        else if (bump_right && !bump_left) direction <= 1'b1;
                        else if (bump_left && bump_right) direction <= ~direction;
                    end
                end
                
                state[1]: begin  // FALL
                    if (ground) begin
                        state <= (fall_timer > 20) ? SPLAT : WALK;
                        fall_timer <= 0;
                    end else begin
                        fall_timer <= fall_timer + 1;
                    end
                end
                
                state[2]: begin  // DIG
                    if (!ground) begin
                        state <= FALL;
                        fall_timer <= 1;
                    end
                end
                
                state[3]: begin  // SPLAT
                    // Stay in SPLAT forever
                end
            endcase
        end
    end

    // Output assignments
    assign walk_left = (state == WALK) & direction;
    assign walk_right = (state == WALK) & ~direction;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule