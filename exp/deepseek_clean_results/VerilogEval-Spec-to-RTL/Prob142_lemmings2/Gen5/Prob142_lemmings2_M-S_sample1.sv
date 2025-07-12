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
    // State encoding - 2 states + direction
    parameter WALK = 1'b0;
    parameter FALL = 1'b1;
    
    reg state;
    reg direction;  // 0=left, 1=right
    
    // State transition logic
    always @(*) begin
        case (state)
            WALK: begin
                if (!ground)
                    state = FALL;
                else if ((direction && bump_right) || (!direction && bump_left))
                    direction = ~direction;
            end
            FALL: begin
                if (ground)
                    state = WALK;
            end
        endcase
    end
    
    // State register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;  // Start walking left
        end else begin
            state <= next_state;
            direction <= next_direction;
        end
    end
    
    // Output logic
    assign walk_left = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah = (state == FALL);
endmodule