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

    parameter WALK_L = 3'b000;
    parameter WALK_R = 3'b001;
    parameter FALL_L = 3'b010;
    parameter FALL_R = 3'b011;
    parameter DIG_L  = 3'b100;
    parameter DIG_R  = 3'b101;
    parameter SPLAT  = 3'b110;
    
    reg [2:0] state;
    reg [4:0] fall_timer;
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            fall_timer <= 0;
        end else begin
            case (state)
                WALK_L: begin
                    if (!ground) begin
                        state <= FALL_L;
                        fall_timer <= 1;
                    end else if (dig) begin
                        state <= DIG_L;
                    end else if (bump_left) begin
                        state <= WALK_R;
                    end
                end
                
                WALK_R: begin
                    if (!ground) begin
                        state <= FALL_R;
                        fall_timer <= 1;
                    end else if (dig) begin
                        state <= DIG_R;
                    end else if (bump_right) begin
                        state <= WALK_L;
                    end
                end
                
                FALL_L: begin
                    if (ground) begin
                        if (fall_timer > 20)
                            state <= SPLAT;
                        else
                            state <= WALK_L;
                        fall_timer <= 0;
                    end else begin
                        fall_timer <= fall_timer + 1;
                    end
                end
                
                FALL_R: begin
                    if (ground) begin
                        if (fall_timer > 20)
                            state <= SPLAT;
                        else
                            state <= WALK_R;
                        fall_timer <= 0;
                    end else begin
                        fall_timer <= fall_timer + 1;
                    end
                end
                
                DIG_L: begin
                    if (!ground) begin
                        state <= FALL_L;
                        fall_timer <= 1;
                    end
                end
                
                DIG_R: begin
                    if (!ground) begin
                        state <= FALL_R;
                        fall_timer <= 1;
                    end
                end
                
                SPLAT: state <= SPLAT;
            endcase
        end
    end
    
    assign walk_left = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah = (state == FALL_L) || (state == FALL_R);
    assign digging = (state == DIG_L) || (state == DIG_R);
    
endmodule