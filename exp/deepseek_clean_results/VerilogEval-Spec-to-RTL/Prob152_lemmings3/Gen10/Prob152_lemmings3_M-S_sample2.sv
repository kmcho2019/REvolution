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

    // States with direction encoded
    parameter WALK_LEFT = 2'd0;
    parameter WALK_RIGHT = 2'd1;
    parameter FALL = 2'd2;
    parameter DIG = 2'd3;
    
    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            
            FALL: begin
                if (ground) begin
                    // Return to previous walking direction
                    next_state = (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT;
                end else begin
                    next_state = FALL;
                end
            end
            
            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                end else begin
                    next_state = DIG;
                end
            end
        endcase
    end

    // State register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule