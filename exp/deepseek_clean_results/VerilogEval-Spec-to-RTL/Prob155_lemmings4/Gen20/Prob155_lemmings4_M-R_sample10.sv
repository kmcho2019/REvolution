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

    // One-hot encoded action states
    reg [3:0] action_state;
    localparam WALK  = 4'b0001;
    localparam FALL  = 4'b0010;
    localparam DIG   = 4'b0100;
    localparam SPLAT = 4'b1000;
    
    // Direction state (separate from action)
    reg moving_left;
    
    // Edge detection
    reg ground_prev;
    wire ground_falling_edge = ground_prev & ~ground;
    wire ground_rising_edge = ~ground_prev & ground;
    
    // Fall counter module
    reg [4:0] fall_cycles;
    wire splatter_condition = (fall_cycles > 20) & ground_rising_edge;
    
    // Direction handling (separate always block)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            moving_left <= 1'b1;
        end else if (action_state == WALK && ground) begin
            case ({bump_left, bump_right})
                2'b10: moving_left <= 1'b0;
                2'b01: moving_left <= 1'b1;
                2'b11: moving_left <= ~moving_left;
                default: ; // No change
            endcase
        end
    end
    
    // Action state transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            action_state <= WALK;
            fall_cycles <= 0;
            ground_prev <= 1'b1;
        end else begin
            ground_prev <= ground;
            
            case (1'b1) // Synthesis will optimize this to priority encoder
                action_state[0]: begin // WALK
                    if (ground_falling_edge) begin
                        action_state <= FALL;
                        fall_cycles <= 1;
                    end else if (ground && dig) begin
                        action_state <= DIG;
                    end
                end
                
                action_state[1]: begin // FALL
                    if (ground_rising_edge) begin
                        action_state <= splatter_condition ? SPLAT : WALK;
                        fall_cycles <= 0;
                    end else if (!ground && fall_cycles < 31) begin
                        fall_cycles <= fall_cycles + 1;
                    end
                end
                
                action_state[2]: begin // DIG
                    if (ground_falling_edge) begin
                        action_state <= FALL;
                        fall_cycles <= 1;
                    end
                end
                
                action_state[3]: begin // SPLAT
                    // Permanent state
                end
            endcase
        end
    end

    // Continuous output assignments
    assign walk_left = action_state[0] & moving_left;
    assign walk_right = action_state[0] & ~moving_left;
    assign aaah = action_state[1];
    assign digging = action_state[2];

endmodule