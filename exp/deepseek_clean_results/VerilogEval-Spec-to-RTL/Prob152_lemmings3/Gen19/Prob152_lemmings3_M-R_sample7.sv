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
    parameter WALK_L = 3'b001;
    parameter WALK_R = 3'b010;
    parameter FALL   = 3'b100;
    parameter DIG    = 3'b000; // Special case handled in logic
    
    reg [2:0] state, next_state;
    reg next_direction, direction;

    // State transition logic
    always @(*) begin
        case (state)
            WALK_L: begin
                if (~ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else if (bump_left) begin
                    next_state = WALK_R;
                end else begin
                    next_state = WALK_L;
                end
            end
            
            WALK_R: begin
                if (~ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else if (bump_right) begin
                    next_state = WALK_L;
                end else begin
                    next_state = WALK_R;
                end
            end
            
            FALL: begin
                if (ground) begin
                    next_state = direction ? WALK_R : WALK_L;
                end else begin
                    next_state = FALL;
                end
            end
            
            default: begin // DIG or others
                if (~ground) begin
                    next_state = FALL;
                end else begin
                    next_state = direction ? WALK_R : WALK_L;
                end
            end
        endcase
    end

    // Direction update logic
    always @(*) begin
        next_direction = direction;
        if (state == WALK_L && bump_left) begin
            next_direction = 1'b1;
        end else if (state == WALK_R && bump_right) begin
            next_direction = 1'b0;
        end
    end

    // State register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            direction <= 1'b0;
        end else begin
            state <= next_state;
            direction <= next_direction;
        end
    end

    // Output logic
    assign walk_left  = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule