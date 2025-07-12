module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // One-hot states
    parameter LEFT = 4'b0001;
    parameter RIGHT = 4'b0010;
    parameter FALL_LEFT = 4'b0100;
    parameter FALL_RIGHT = 4'b1000;
    
    reg [3:0] state;
    reg ground_prev;
    
    // Edge detection
    wire ground_fall = ground_prev && !ground;
    wire ground_rise = !ground_prev && ground;
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
            ground_prev <= 1;
        end else begin
            ground_prev <= ground;
            
            case (state)
                LEFT: begin
                    if (ground_fall) begin
                        state <= FALL_LEFT;
                    end else if (bump_left) begin
                        state <= RIGHT;
                    end
                end
                
                RIGHT: begin
                    if (ground_fall) begin
                        state <= FALL_RIGHT;
                    end else if (bump_right) begin
                        state <= LEFT;
                    end
                end
                
                FALL_LEFT: begin
                    if (ground_rise) begin
                        state <= LEFT;
                    end
                end
                
                FALL_RIGHT: begin
                    if (ground_rise) begin
                        state <= RIGHT;
                    end
                end
            endcase
        end
    end
    
    // Output logic
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALL_LEFT) || (state == FALL_RIGHT);

endmodule