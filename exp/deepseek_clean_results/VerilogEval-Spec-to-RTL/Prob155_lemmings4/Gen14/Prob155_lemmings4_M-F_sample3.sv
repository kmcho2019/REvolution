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
    parameter LEFT = 0, RIGHT = 1, FALLING = 2, DIGGING = 3, SPLAT = 4;
    reg [2:0] state;
    reg direction; // 0=left, 1=right
    reg [4:0] fall_timer;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
            direction <= 0;
            fall_timer <= 0;
        end else begin
            case (state)
                LEFT, RIGHT: begin
                    if (!ground) begin
                        state <= FALLING;
                        fall_timer <= 0;
                    end else if (dig && ground) begin
                        state <= DIGGING;
                    end else if ((state == LEFT && bump_left) || 
                               (state == RIGHT && bump_right)) begin
                        state <= (state == LEFT) ? RIGHT : LEFT;
                        direction <= (state == LEFT);
                    end else if (bump_left && bump_right) begin
                        state <= (state == LEFT) ? RIGHT : LEFT;
                        direction <= (state == LEFT);
                    end
                end
                
                DIGGING: begin
                    if (!ground) begin
                        state <= FALLING;
                        fall_timer <= 0;
                    end
                end
                
                FALLING: begin
                    if (ground) begin
                        if (fall_timer > 20)
                            state <= SPLAT;
                        else
                            state <= direction ? RIGHT : LEFT;
                    end else begin
                        fall_timer <= fall_timer + 1;
                    end
                end
                
                SPLAT: state <= SPLAT;
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);

endmodule