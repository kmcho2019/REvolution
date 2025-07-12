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
    parameter WALK = 1'b0;
    parameter FALL = 1'b1;
    
    reg state;
    reg direction; // 0=left, 1=right
    reg next_state;
    reg next_direction;
    
    always @(*) begin
        // Default assignments
        next_state = state;
        next_direction = direction;
        
        case (state)
            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (bump_left) begin
                    next_direction = 1'b1; // turn right
                end else if (bump_right) begin
                    next_direction = 1'b0; // turn left
                end
            end
            FALL: begin
                if (ground) begin
                    next_state = WALK;
                end
            end
        endcase
    end
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0; // start walking left
        end else begin
            state <= next_state;
            direction <= next_direction;
        end
    end
    
    assign walk_left = (state == WALK) & ~direction;
    assign walk_right = (state == WALK) & direction;
    assign aaah = (state == FALL);
    
endmodule