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
    // One-hot state encoding
    parameter WALK_L = 3'b001;
    parameter WALK_R = 3'b010;
    parameter FALL   = 3'b100;
    parameter DIG_L  = 3'b101; // Digging left
    parameter DIG_R  = 3'b110; // Digging right
    
    reg [2:0] state, next_state;
    
    // Combined state transition and output logic
    always @(*) begin
        next_state = state;
        
        case (1'b1) // Synthesis will optimize this
            state[0]: begin // WALK_L
                if (~ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG_L;
                end else if (bump_left) begin
                    next_state = WALK_R;
                end
            end
            
            state[1]: begin // WALK_R
                if (~ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG_R;
                end else if (bump_right) begin
                    next_state = WALK_L;
                end
            end
            
            state[2]: begin // FALL
                if (ground) begin
                    // Return to previous walking direction
                    next_state = (state == DIG_L || state == WALK_L) ? WALK_L : WALK_R;
                end
            end
            
            default: begin // DIG_L or DIG_R
                if (~ground) begin
                    next_state = FALL;
                end
            end
        endcase
    end
    
    // Sequential logic with integrated output generation
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            {walk_left, walk_right, aaah, digging} <= 4'b1000;
        end else begin
            state <= next_state;
            
            // Output generation
            walk_left  <= (next_state == WALK_L);
            walk_right <= (next_state == WALK_R);
            aaah       <= (next_state == FALL);
            digging    <= (next_state == DIG_L || next_state == DIG_R);
        end
    end
    
endmodule