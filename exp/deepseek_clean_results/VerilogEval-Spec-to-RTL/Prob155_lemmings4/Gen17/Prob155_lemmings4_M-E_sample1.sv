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

    // Movement direction states
    reg moving_left;  // 1 = left, 0 = right
    
    // Action states
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;
    parameter SPLAT = 2'b11;
    reg [1:0] action_state;
    
    // Edge detection for ground
    reg ground_prev;
    wire ground_falling_edge = ground_prev & ~ground;
    wire ground_rising_edge = ~ground_prev & ground;
    
    // Fall timer (5 bits, saturates at 31)
    reg [4:0] fall_cycles;
    
    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            moving_left <= 1'b1;
            action_state <= WALK;
            fall_cycles <= 0;
            ground_prev <= 1'b1;
        end else begin
            ground_prev <= ground;
            
            case (action_state)
                WALK: begin
                    if (ground_falling_edge) begin
                        action_state <= FALL;
                        fall_cycles <= 1;
                    end else if (ground && dig) begin
                        action_state <= DIG;
                    end else if (ground) begin
                        // Handle direction changes
                        case ({bump_left, bump_right})
                            2'b10: moving_left <= 1'b0;
                            2'b01: moving_left <= 1'b1;
                            2'b11: moving_left <= ~moving_left;
                            default: ; // No change
                        endcase
                    end
                end
                
                FALL: begin
                    if (ground_rising_edge) begin
                        if (fall_cycles > 20)
                            action_state <= SPLAT;
                        else
                            action_state <= WALK;
                        fall_cycles <= 0;
                    end else if (!ground) begin
                        // Saturating counter
                        if (fall_cycles < 31)
                            fall_cycles <= fall_cycles + 1;
                    end
                end
                
                DIG: begin
                    if (ground_falling_edge) begin
                        action_state <= FALL;
                        fall_cycles <= 1;
                    end
                end
                
                SPLAT: begin
                    // Permanent state
                end
            endcase
        end
    end

    // Output assignments
    assign walk_left = (action_state == WALK) & moving_left;
    assign walk_right = (action_state == WALK) & ~moving_left;
    assign aaah = (action_state == FALL);
    assign digging = (action_state == DIG);

endmodule