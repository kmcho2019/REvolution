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

    // Hierarchical state encoding
    parameter MAIN_WALK = 2'b00;
    parameter MAIN_FALL = 2'b01;
    parameter SUB_WALK = 1'b0;
    parameter SUB_DIG  = 1'b1;

    reg [1:0] main_state;
    reg sub_state;
    reg direction;      // Current walking direction
    reg saved_dir;      // Saved direction during fall
    
    // Edge detection for ground
    reg ground_prev;
    wire ground_falling = ~ground & ground_prev;
    wire ground_rising = ground & ~ground_prev;

    // Output registers
    reg walk_left_reg, walk_right_reg, aaah_reg, digging_reg;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            main_state <= MAIN_WALK;
            sub_state <= SUB_WALK;
            direction <= 0;
            saved_dir <= 0;
            ground_prev <= 1;
        end else begin
            ground_prev <= ground;
            
            case (main_state)
                MAIN_WALK: begin
                    if (ground_falling) begin
                        main_state <= MAIN_FALL;
                        saved_dir <= direction;
                    end
                    else if (ground) begin
                        // Handle sub-states
                        case (sub_state)
                            SUB_WALK: begin
                                if (dig) begin
                                    sub_state <= SUB_DIG;
                                end
                                else if (bump_left || bump_right) begin
                                    direction <= bump_left;
                                end
                            end
                            
                            SUB_DIG: begin
                                if (ground_falling) begin
                                    sub_state <= SUB_WALK;
                                end
                            end
                        endcase
                    end
                end
                
                MAIN_FALL: begin
                    if (ground_rising) begin
                        main_state <= MAIN_WALK;
                        direction <= saved_dir;
                    end
                end
            endcase
        end
    end

    // Output logic with pipelining
    always @(posedge clk) begin
        walk_left_reg  <= (main_state == MAIN_WALK) && (sub_state == SUB_WALK) && !direction;
        walk_right_reg <= (main_state == MAIN_WALK) && (sub_state == SUB_WALK) && direction;
        aaah_reg      <= (main_state == MAIN_FALL);
        digging_reg   <= (main_state == MAIN_WALK) && (sub_state == SUB_DIG);
    end

    assign walk_left  = walk_left_reg;
    assign walk_right = walk_right_reg;
    assign aaah       = aaah_reg;
    assign digging    = digging_reg;

endmodule