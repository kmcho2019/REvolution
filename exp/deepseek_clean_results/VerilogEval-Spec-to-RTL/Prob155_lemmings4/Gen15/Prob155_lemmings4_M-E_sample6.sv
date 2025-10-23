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
    parameter DIR_LEFT = 1'b0;
    parameter DIR_RIGHT = 1'b1;
    
    reg [2:0] state;  // {falling, digging, direction}
    reg splat;
    reg [4:0] fall_timer;
    reg ground_prev;

    // Edge detection for ground signal
    wire ground_falling = ground_prev & ~ground;
    wire ground_rising = ~ground_prev & ground;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= {1'b0, 1'b0, DIR_LEFT};
            splat <= 1'b0;
            fall_timer <= 0;
            ground_prev <= 1'b1;
        end else begin
            ground_prev <= ground;
            
            if (splat) begin
                // Permanent splat state - no changes
            end else begin
                // Handle falling edge of ground
                if (ground_falling) begin
                    state[2] <= 1'b1;  // Set falling flag
                    fall_timer <= 0;
                end
                
                // Handle rising edge of ground
                if (ground_rising && state[2]) begin
                    state[2] <= 1'b0;  // Clear falling flag
                    if (fall_timer > 20) begin
                        splat <= 1'b1;
                    end
                end
                
                // Increment fall timer while falling
                if (state[2] && ~ground) begin
                    fall_timer <= fall_timer + 1;
                end
                
                // State transitions when not falling
                if (~state[2]) begin
                    // Priority 1: Start digging if conditions met
                    if (dig && ground && ~state[1]) begin
                        state[1] <= 1'b1;
                    end
                    // Priority 2: Stop digging if ground disappears
                    else if (state[1] && ~ground) begin
                        state[1] <= 1'b0;
                        state[2] <= 1'b1;  // Start falling
                        fall_timer <= 0;
                    end
                    // Priority 3: Handle bumps when walking normally
                    else if (~state[1] && (bump_left || bump_right)) begin
                        state[0] <= bump_left ? DIR_RIGHT : DIR_LEFT;
                    end
                end
            end
        end
    end

    // Output logic
    assign walk_left = ~splat & ~state[2] & ~state[1] & ~state[0];
    assign walk_right = ~splat & ~state[2] & ~state[1] & state[0];
    assign aaah = ~splat & state[2];
    assign digging = ~splat & state[1];
    
endmodule