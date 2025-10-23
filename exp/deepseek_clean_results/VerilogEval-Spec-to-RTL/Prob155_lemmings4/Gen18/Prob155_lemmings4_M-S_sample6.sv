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

    parameter LEFT = 3'b000;
    parameter RIGHT = 3'b001;
    parameter FALLING_L = 3'b010;
    parameter FALLING_R = 3'b011;
    parameter DIGGING_L = 3'b100;
    parameter DIGGING_R = 3'b101;
    parameter SPLATTER = 3'b110;
    
    reg [2:0] state;
    reg [4:0] fall_timer;
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
            fall_timer <= 0;
        end else begin
            case (state)
                LEFT, RIGHT: begin
                    if (!ground) begin
                        state <= (state == LEFT) ? FALLING_L : FALLING_R;
                        fall_timer <= 1;
                    end else if (dig) begin
                        state <= (state == LEFT) ? DIGGING_L : DIGGING_R;
                    end else if ((state == LEFT && bump_left) || 
                                (state == RIGHT && bump_right) ||
                                (bump_left && bump_right)) begin
                        state <= (state == LEFT) ? RIGHT : LEFT;
                    end
                end
                
                FALLING_L, FALLING_R: begin
                    if (ground) begin
                        if (fall_timer > 20)
                            state <= SPLATTER;
                        else
                            state <= (state == FALLING_L) ? LEFT : RIGHT;
                    end else begin
                        fall_timer <= fall_timer + 1;
                    end
                end
                
                DIGGING_L, DIGGING_R: begin
                    if (!ground) begin
                        state <= (state == DIGGING_L) ? FALLING_L : FALLING_R;
                        fall_timer <= 1;
                    end
                end
                
                SPLATTER: state <= SPLATTER;
            endcase
        end
    end
    
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALLING_L || state == FALLING_R);
    assign digging = (state == DIGGING_L || state == DIGGING_R);
    
endmodule