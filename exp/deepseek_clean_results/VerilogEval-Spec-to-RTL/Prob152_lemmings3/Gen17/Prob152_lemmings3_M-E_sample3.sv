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

    // Movement states
    localparam WALKING = 2'b00;
    localparam FALLING = 2'b01;
    localparam DIGGING = 2'b10;
    
    reg [1:0] movement_state;
    reg direction; // 0=left, 1=right
    
    // Edge detection for ground
    reg ground_prev;
    wire ground_falling = ground_prev & ~ground;
    wire ground_rising = ~ground_prev & ground;
    
    // Bump priority encoder
    wire bump_occurred = bump_left | bump_right;
    wire new_direction = bump_left ? 1'b1 : 1'b0;
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            movement_state <= WALKING;
            direction <= 1'b0;
            ground_prev <= 1'b1;
        end else begin
            ground_prev <= ground;
            
            case (movement_state)
                WALKING: begin
                    if (ground_falling) begin
                        movement_state <= FALLING;
                    end else if (dig & ground) begin
                        movement_state <= DIGGING;
                    end else if (bump_occurred) begin
                        direction <= new_direction;
                    end
                end
                
                FALLING: begin
                    if (ground_rising) begin
                        movement_state <= WALKING;
                    end
                end
                
                DIGGING: begin
                    if (ground_falling) begin
                        movement_state <= FALLING;
                    end
                end
            endcase
        end
    end
    
    // Output logic
    assign walk_left = (movement_state == WALKING) & ~direction;
    assign walk_right = (movement_state == WALKING) & direction;
    assign aaah = (movement_state == FALLING);
    assign digging = (movement_state == DIGGING);

endmodule