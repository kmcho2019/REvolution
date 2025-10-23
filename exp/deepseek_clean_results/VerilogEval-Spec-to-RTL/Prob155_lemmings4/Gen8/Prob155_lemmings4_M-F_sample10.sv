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
    reg fall_direction; // 0 for left, 1 for right

    // State transition
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 0;
            fall_direction <= 0;
        end else begin
            case (state)
                WALK_LEFT: begin
                    if (~ground) begin
                        state <= FALL;
                        fall_counter <= 1;
                        fall_direction <= 0;
                    end else if (dig) begin
                        state <= DIG_LEFT;
                    end else if (bump_left) begin
                        state <= WALK_RIGHT;
                    end else if (bump_right) begin
                        state <= WALK_LEFT; // Stay left if bumped right
                    end
                end
                
                WALK_RIGHT: begin
                    if (~ground) begin
                        state <= FALL;
                        fall_counter <= 1;
                        fall_direction <= 1;
                    end else if (dig) begin
                        state <= DIG_RIGHT;
                    end else if (bump_right) begin
                        state <= WALK_LEFT;
                    end else if (bump_left) begin
                        state <= WALK_RIGHT; // Stay right if bumped left
                    end
                end
                
                DIG_LEFT: begin
                    if (~ground) begin
                        state <= FALL;
                        fall_counter <= 1;
                        fall_direction <= 0;
                    end else if (~dig) begin
                        state <= WALK_LEFT;
                    end
                end
                
                DIG_RIGHT: begin
                    if (~ground) begin
                        state <= FALL;
                        fall_counter <= 1;
                        fall_direction <= 1;
                    end else if (~dig) begin
                        state <= WALK_RIGHT;
                    end
                end
                
                FALL: begin
                    if (ground) begin
                        if (fall_counter > 20) begin
                            state <= SPLAT;
                        end else begin
                            state <= fall_direction ? WALK_RIGHT : WALK_LEFT;
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