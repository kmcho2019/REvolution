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

    // Combined direction and activity states
    parameter WALK_LEFT = 3'b000;
    parameter WALK_RIGHT = 3'b001;
    parameter DIG_LEFT = 3'b010;
    parameter DIG_RIGHT = 3'b011;
    parameter FALL_LEFT = 3'b100;
    parameter FALL_RIGHT = 3'b101;
    parameter SPLAT = 3'b110;

    reg [2:0] state;
    reg [4:0] fall_counter;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 0;
        end else begin
            case (state)
                WALK_LEFT, WALK_RIGHT: begin
                    if (!ground) begin
                        state <= (state == WALK_LEFT) ? FALL_LEFT : FALL_RIGHT;
                        fall_counter <= 1;
                    end else if (dig) begin
                        state <= (state == WALK_LEFT) ? DIG_LEFT : DIG_RIGHT;
                    end else if (bump_left || bump_right) begin
                        if (state == WALK_LEFT && bump_left)
                            state <= WALK_RIGHT;
                        else if (state == WALK_RIGHT && bump_right)
                            state <= WALK_LEFT;
                    end
                end
                
                DIG_LEFT, DIG_RIGHT: begin
                    if (!ground) begin
                        state <= (state == DIG_LEFT) ? FALL_LEFT : FALL_RIGHT;
                        fall_counter <= 1;
                    end
                end
                
                FALL_LEFT, FALL_RIGHT: begin
                    if (ground) begin
                        if (fall_counter > 20)
                            state <= SPLAT;
                        else
                            state <= (state == FALL_LEFT) ? WALK_LEFT : WALK_RIGHT;
                        fall_counter <= 0;
                    end else begin
                        fall_counter <= fall_counter + 1;
                    end
                end
                
                SPLAT: begin
                    // Stay in SPLAT state forever
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL_LEFT || state == FALL_RIGHT);
    assign digging = (state == DIG_LEFT || state == DIG_RIGHT);

endmodule