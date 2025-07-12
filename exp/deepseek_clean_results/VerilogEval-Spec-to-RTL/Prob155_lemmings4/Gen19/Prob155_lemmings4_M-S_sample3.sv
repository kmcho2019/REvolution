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

    parameter LEFT = 0;
    parameter RIGHT = 1;
    parameter DIG = 2;
    parameter FALL = 3;
    parameter SPLAT = 4;
    
    reg [2:0] state;
    reg [4:0] fall_counter;
    
    // Output assignments
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);
    
    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
            fall_counter <= 0;
        end else begin
            case (state)
                LEFT, RIGHT: begin
                    if (!ground) begin
                        state <= FALL;
                        fall_counter <= 0;
                    end else if (dig) begin
                        state <= DIG;
                    end else if ((state == LEFT && bump_left) || 
                               (state == RIGHT && bump_right)) begin
                        state <= (state == LEFT) ? RIGHT : LEFT;
                    end
                end
                
                DIG: begin
                    if (!ground) begin
                        state <= FALL;
                        fall_counter <= 0;
                    end
                end
                
                FALL: begin
                    if (ground) begin
                        if (fall_counter >= 20) begin
                            state <= SPLAT;
                        end else begin
                            state <= (fall_counter == 0) ? 
                                    (state == LEFT ? LEFT : RIGHT) : 
                                    (fall_counter[0] ? LEFT : RIGHT);
                        end
                    end else begin
                        fall_counter <= fall_counter + 1;
                    end
                end
                
                SPLAT: begin
                    // Stay in splat state forever
                    state <= SPLAT;
                end
            endcase
        end
    end

endmodule