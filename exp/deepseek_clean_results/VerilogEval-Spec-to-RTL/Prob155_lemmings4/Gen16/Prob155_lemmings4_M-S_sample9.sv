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
    parameter WALK_L = 0;
    parameter WALK_R = 1;
    parameter DIG_L  = 2;
    parameter DIG_R  = 3;
    parameter FALL_L = 4;
    parameter FALL_R = 5;
    parameter SPLAT  = 6;
    
    reg [2:0] state;
    reg [4:0] fall_counter;

    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            fall_counter <= 0;
        end else begin
            case (state)
                WALK_L, WALK_R: begin
                    if (!ground) begin
                        state <= (state == WALK_L) ? FALL_L : FALL_R;
                        fall_counter <= 0;
                    end else if (dig) begin
                        state <= (state == WALK_L) ? DIG_L : DIG_R;
                    end else if ((state == WALK_L && bump_left) || 
                                (state == WALK_R && bump_right)) begin
                        state <= (state == WALK_L) ? WALK_R : WALK_L;
                    end
                end
                
                DIG_L, DIG_R: begin
                    if (!ground) begin
                        state <= (state == DIG_L) ? FALL_L : FALL_R;
                        fall_counter <= 0;
                    end
                end
                
                FALL_L, FALL_R: begin
                    if (ground) begin
                        if (fall_counter > 20)
                            state <= SPLAT;
                        else
                            state <= (state == FALL_L) ? WALK_L : WALK_R;
                    end else begin
                        fall_counter <= fall_counter + 1;
                    end
                end
                
                SPLAT: state <= SPLAT;
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == WALK_L) || (state == DIG_L) || (state == FALL_L);
    assign walk_right = (state == WALK_R) || (state == DIG_R) || (state == FALL_R);
    assign aaah = (state == FALL_L) || (state == FALL_R);
    assign digging = (state == DIG_L) || (state == DIG_R);

endmodule