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

    // Primary states
    parameter WALKING = 2'b00;
    parameter DIGGING = 2'b01;
    parameter FALLING = 2'b10;
    parameter SPLATTER = 2'b11;
    
    // Direction states
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg [1:0] primary_state;
    reg direction;
    reg original_direction;  // Preserves direction during falls/digging
    reg [4:0] fall_timer;
    reg ground_prev;
    
    // Event priority encoder
    wire should_fall = !ground;
    wire should_dig = dig && ground && (primary_state == WALKING);
    wire should_bump = (bump_left && direction == LEFT) || 
                      (bump_right && direction == RIGHT);
    
    // Edge detection for ground
    wire ground_rising = ground && !ground_prev;
    wire ground_falling = !ground && ground_prev;
    
    // Output logic
    assign walk_left = (primary_state == WALKING) && (direction == LEFT) && !aaah;
    assign walk_right = (primary_state == WALKING) && (direction == RIGHT) && !aaah;
    assign aaah = (primary_state == FALLING);
    assign digging = (primary_state == DIGGING);
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            primary_state <= WALKING;
            direction <= LEFT;
            original_direction <= LEFT;
            fall_timer <= 0;
            ground_prev <= 1;
        end else begin
            ground_prev <= ground;
            
            case (primary_state)
                WALKING: begin
                    if (ground_falling) begin
                        primary_state <= FALLING;
                        fall_timer <= 0;
                    end else if (should_dig) begin
                        primary_state <= DIGGING;
                        original_direction <= direction;
                    end else if (should_bump) begin
                        direction <= ~direction;
                    end
                end
                
                DIGGING: begin
                    if (ground_falling) begin
                        primary_state <= FALLING;
                        fall_timer <= 0;
                    end
                end
                
                FALLING: begin
                    if (!ground) begin
                        fall_timer <= fall_timer + 1;
                    end
                    
                    if (ground_rising) begin
                        if (fall_timer > 20) begin
                            primary_state <= SPLATTER;
                        end else begin
                            primary_state <= WALKING;
                            direction <= original_direction;
                        end
                    end
                end
                
                SPLATTER: begin
                    // Stay in splatter state forever
                    primary_state <= SPLATTER;
                end
            endcase
        end
    end

endmodule