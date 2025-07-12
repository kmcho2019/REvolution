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

    // Main states (Gray coded)
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b11;
    
    // Direction states
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;

    reg [1:0] main_state;
    reg direction;
    reg ground_prev;
    
    // Edge detection
    wire ground_falling = ground_prev & ~ground;
    wire ground_rising = ~ground_prev & ground;
    
    // Bump sampling signals
    wire bump_left_sampled;
    wire bump_right_sampled;
    
    // Output registers
    reg walk_left_reg;
    reg walk_right_reg;
    reg aaah_reg;
    reg digging_reg;
    
    // Bump sampling logic
    assign bump_left_sampled = bump_left & (main_state == WALK) & ground;
    assign bump_right_sampled = bump_right & (main_state == WALK) & ground;
    
    // Main state transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            main_state <= WALK;
            direction <= LEFT;
            ground_prev <= 1'b1;
        end else begin
            ground_prev <= ground;
            
            case (main_state)
                WALK: begin
                    if (ground_falling) begin
                        main_state <= FALL;
                    end else if (dig & ground) begin
                        main_state <= DIG;
                    end
                end
                
                FALL: begin
                    if (ground_rising) begin
                        main_state <= WALK;
                    end
                end
                
                DIG: begin
                    if (ground_falling) begin
                        main_state <= FALL;
                    end
                end
            endcase
            
            // Direction changes only during WALK state with ground
            if (main_state == WALK && ground) begin
                case ({bump_left_sampled, bump_right_sampled})
                    2'b10: direction <= RIGHT;
                    2'b01: direction <= LEFT;
                    default: ; // Maintain direction
                endcase
            end
        end
    end
    
    // Output logic with gating
    always @(*) begin
        walk_left_reg = (main_state == WALK) & ~direction;
        walk_right_reg = (main_state == WALK) & direction;
        aaah_reg = (main_state == FALL);
        digging_reg = (main_state == DIG);
    end
    
    assign walk_left = walk_left_reg;
    assign walk_right = walk_right_reg;
    assign aaah = aaah_reg;
    assign digging = digging_reg;

endmodule