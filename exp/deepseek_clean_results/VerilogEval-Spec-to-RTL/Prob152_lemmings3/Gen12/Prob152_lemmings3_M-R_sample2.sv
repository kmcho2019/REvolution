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

    // One-hot state encoding
    parameter WALK_L = 4'b0001;
    parameter WALK_R = 4'b0010;
    parameter FALL   = 4'b0100;
    parameter DIG    = 4'b1000;
    
    reg [3:0] state;
    reg walking_left;  // Tracks walking direction
    
    // State transitions with explicit priority
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            walking_left <= 1;
        end
        else begin
            case (1'b1) // Synthesis will optimize this
                state[0]: begin // WALK_L
                    if (!ground)       state <= FALL;
                    else if (dig)      state <= DIG;
                    else if (bump_left) begin
                        state <= WALK_R;
                        walking_left <= 0;
                    end
                end
                
                state[1]: begin // WALK_R
                    if (!ground)       state <= FALL;
                    else if (dig)      state <= DIG;
                    else if (bump_right) begin
                        state <= WALK_L;
                        walking_left <= 1;
                    end
                end
                
                state[2]: begin // FALL
                    if (ground) state <= walking_left ? WALK_L : WALK_R;
                end
                
                state[3]: begin // DIG
                    if (!ground) state <= FALL;
                end
            endcase
        end
    end

    // Output assignments
    assign walk_left  = state[0];  // WALK_L
    assign walk_right = state[1];  // WALK_R
    assign aaah       = state[2];  // FALL
    assign digging    = state[3];  // DIG

endmodule