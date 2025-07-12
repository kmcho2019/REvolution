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

    // Define states
    parameter WALK = 2'd0;
    parameter FALL = 2'd1;
    parameter DIG  = 2'd2;

    reg [1:0] state, next_state;
    reg direction, next_direction; // 0=left, 1=right

    // State transition logic
    always @(*) begin
        next_state = state;
        next_direction = direction;
        
        case (state)
            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                end
                else if (dig) begin
                    next_state = DIG;
                end
                else if ((bump_left && !direction) || (bump_right && direction)) begin
                    next_direction = ~direction;
                end
            end
            
            FALL: begin
                if (ground) begin
                    next_state = WALK;
                end
            end
            
            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                end
            end
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0; // start walking left
        end
        else begin
            state <= next_state;
            direction <= next_direction;
        end
    end

    // Output logic
    assign walk_left = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule