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

    // States
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter BUMP = 2'b10;
    
    reg [1:0] state, next_state;
    reg dir;  // 0=left, 1=right
    
    // State transitions
    always @(*) begin
        case (state)
            WALK: begin
                if (!ground) next_state = FALL;
                else if (bump_left || bump_right) next_state = BUMP;
                else next_state = WALK;
            end
            FALL: begin
                if (ground) next_state = WALK;
                else next_state = FALL;
            end
            BUMP: next_state = WALK;
            default: next_state = WALK;
        endcase
    end
    
    // Direction and state registers
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir <= 0;  // Start walking left
        end
        else begin
            state <= next_state;
            
            // Update direction when in BUMP state
            if (state == BUMP) begin
                if (bump_left && bump_right) dir <= ~dir;  // Toggle if both bumps
                else if (bump_left) dir <= 1;  // Switch to right
                else if (bump_right) dir <= 0;  // Switch to left
            end
        end
    end
    
    // Output logic
    assign walk_left = (state == WALK) && !dir;
    assign walk_right = (state == WALK) && dir;
    assign aaah = (state == FALL);

endmodule