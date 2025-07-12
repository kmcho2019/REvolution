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

    // States
    parameter WALK_LEFT = 3'd0;
    parameter WALK_RIGHT = 3'd1;
    parameter DIG_LEFT = 3'd2;
    parameter DIG_RIGHT = 3'd3;
    parameter FALL = 3'd4;
    parameter SPLAT = 3'd5;

    reg [2:0] state;
    reg [4:0] fall_counter;

    // State transition
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 0;
        end else begin
            case (state)
                WALK_LEFT, WALK_RIGHT: begin
                    if (~ground) begin
                        state <= FALL;
                        fall_counter <= 1;
                    end else if (dig) begin
                        state <= (state == WALK_LEFT) ? DIG_LEFT : DIG_RIGHT;
                    end else begin
                        if (bump_left && state == WALK_LEFT) state <= WALK_RIGHT;
                        if (bump_right && state == WALK_RIGHT) state <= WALK_LEFT;
                    end
                end
                
                DIG_LEFT, DIG_RIGHT: begin
                    if (~ground) begin
                        state <= FALL;
                        fall_counter <= 1;
                    end
                end
                
                FALL: begin
                    if (ground) begin
                        if (fall_counter > 20) begin
                            state <= SPLAT;
                        end else begin
                            state <= (state == DIG_LEFT || (state == FALL && fall_counter == 1 && $past(state) == WALK_LEFT)) ? 
                                    WALK_LEFT : WALK_RIGHT;
                        end
                        fall_counter <= 0;
                    end else begin
                        fall_counter <= fall_counter + 1;
                    end
                end
                
                SPLAT: begin
                    // Stay in SPLAT forever
                    state <= SPLAT;
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG_LEFT || state == DIG_RIGHT);

endmodule