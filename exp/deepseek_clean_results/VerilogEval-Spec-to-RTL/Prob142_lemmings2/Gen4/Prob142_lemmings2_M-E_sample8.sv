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
    // Gray code state encoding for minimal transitions
    parameter IDLE      = 2'b00;  // Not used, just for completeness
    parameter WALK_L    = 2'b01;
    parameter WALK_R    = 2'b11;
    parameter FALLING   = 2'b10;
    
    reg [1:0] state, next_state;
    reg direction;  // 0 for left, 1 for right
    
    // Bump memory registers
    reg bump_left_reg, bump_right_reg;
    
    // Priority-based state transition logic
    always @(*) begin
        case (state)
            WALK_L: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left_reg) begin
                    next_state = WALK_R;
                end else begin
                    next_state = WALK_L;
                end
            end
            WALK_R: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_right_reg) begin
                    next_state = WALK_L;
                end else begin
                    next_state = WALK_R;
                end
            end
            FALLING: begin
                if (ground) begin
                    next_state = direction ? WALK_R : WALK_L;
                end else begin
                    next_state = FALLING;
                end
            end
            default: next_state = WALK_L;
        endcase
    end
    
    // Sequential logic with bump memory
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            direction <= 0;
            bump_left_reg <= 0;
            bump_right_reg <= 0;
        end else begin
            state <= next_state;
            
            // Update bump memory only when not falling
            if (state != FALLING) begin
                bump_left_reg <= bump_left;
                bump_right_reg <= bump_right;
            end
            
            // Update direction register
            case (next_state)
                WALK_L: direction <= 0;
                WALK_R: direction <= 1;
                default: ; // Maintain direction during falling
            endcase
        end
    end
    
    // Output logic
    assign walk_left = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah = (state == FALLING);
    
endmodule