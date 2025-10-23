module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // One-hot encoded states with direction
    parameter [5:0] WALK_L = 6'b000001;
    parameter [5:0] WALK_R = 6'b000010;
    parameter [5:0] FALL_L = 6'b000100;
    parameter [5:0] FALL_R = 6'b001000;
    parameter [5:0] DIG_L  = 6'b010000;
    parameter [5:0] DIG_R  = 6'b100000;

    reg [5:0] state, next_state;

    // State transition logic
    always @(*) begin
        next_state = state;
        
        case (1'b1) // synthesis parallel_case
            state[0]: begin // WALK_L
                if (!ground)          next_state = FALL_L;
                else if (dig)         next_state = DIG_L;
                else if (bump_left)    next_state = WALK_R;
            end
            
            state[1]: begin // WALK_R
                if (!ground)          next_state = FALL_R;
                else if (dig)        next_state = DIG_R;
                else if (bump_right)  next_state = WALK_L;
            end
            
            state[2]: begin // FALL_L
                if (ground) next_state = WALK_L;
            end
            
            state[3]: begin // FALL_R
                if (ground) next_state = WALK_R;
            end
            
            state[4]: begin // DIG_L
                if (!ground) next_state = FALL_L;
            end
            
            state[5]: begin // DIG_R
                if (!ground) next_state = FALL_R;
            end
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
        end
        else begin
            state <= next_state;
        end
    end

    // Registered output logic
    always @(posedge clk) begin
        walk_left  <= state[0];  // WALK_L
        walk_right <= state[1];  // WALK_R
        aaah       <= state[2] | state[3]; // FALL_L or FALL_R
        digging    <= state[4] | state[5]; // DIG_L or DIG_R
    end

endmodule