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

    parameter WL = 3'b000;  // Walk left
    parameter WR = 3'b001;  // Walk right
    parameter FL = 3'b010;  // Fall (from left)
    parameter FR = 3'b011;  // Fall (from right)
    parameter DL = 3'b100;  // Dig (from left)
    parameter DR = 3'b101;  // Dig (from right)
    parameter SPLAT = 3'b110;
    
    reg [2:0] state;
    reg [4:0] fall_timer;
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WL;
            fall_timer <= 0;
        end else begin
            case (state)
                WL: begin
                    if (!ground) begin
                        state <= FL;
                        fall_timer <= 1;
                    end else if (dig) begin
                        state <= DL;
                    end else if (bump_left) begin
                        state <= WR;
                    end
                end
                
                WR: begin
                    if (!ground) begin
                        state <= FR;
                        fall_timer <= 1;
                    end else if (dig) begin
                        state <= DR;
                    end else if (bump_right) begin
                        state <= WL;
                    end
                end
                
                FL, FR: begin
                    if (ground) begin
                        if (fall_timer > 20) begin
                            state <= SPLAT;
                        end else begin
                            state <= (state == FL) ? WL : WR;
                        end
                        fall_timer <= 0;
                    end else begin
                        fall_timer <= fall_timer + 1;
                    end
                end
                
                DL: begin
                    if (!ground) begin
                        state <= FL;
                        fall_timer <= 1;
                    end
                end
                
                DR: begin
                    if (!ground) begin
                        state <= FR;
                        fall_timer <= 1;
                    end
                end
                
                SPLAT: state <= SPLAT;
            endcase
        end
    end
    
    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FL || state == FR);
    assign digging = (state == DL || state == DR);
    
endmodule