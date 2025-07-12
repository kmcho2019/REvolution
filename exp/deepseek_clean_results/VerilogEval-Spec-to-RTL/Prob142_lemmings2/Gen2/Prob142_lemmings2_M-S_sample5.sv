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

    // Define states
    parameter WALK_LEFT = 1'b0;
    parameter WALK_RIGHT = 1'b1;
    parameter FALL = 2'b10;
    
    reg [1:0] state; // [1] = is_falling, [0] = direction (0=left, 1=right)
    
    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= {1'b0, WALK_LEFT}; // Start walking left
        end else begin
            if (state[1]) begin // Currently falling
                if (ground) begin
                    state <= {1'b0, state[0]}; // Return to previous walking state
                end
            end else begin // Currently walking
                if (!ground) begin
                    state <= {1'b1, state[0]}; // Fall while remembering direction
                end else if ((state[0] && bump_right) || (!state[0] && bump_left)) begin
                    state <= {1'b0, ~state[0]}; // Switch direction
                end
            end
        end
    end
    
    // Output logic
    assign walk_left = (~state[1]) & (~state[0]);
    assign walk_right = (~state[1]) & state[0];
    assign aaah = state[1];

endmodule