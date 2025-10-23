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
    // State encoding - 2 bits
    parameter WALK_L = 2'b00;
    parameter WALK_R = 2'b01;
    parameter FALL   = 2'b10;
    parameter DIG    = 2'b11;
    
    reg [1:0] state, next_state;
    
    // State transition logic
    always @(*) begin
        case (state)
            WALK_L: begin
                if (~ground)       next_state = FALL;
                else if (dig)      next_state = DIG;
                else if (bump_left) next_state = WALK_R;
                else               next_state = WALK_L;
            end
            WALK_R: begin
                if (~ground)       next_state = FALL;
                else if (dig)      next_state = DIG;
                else if (bump_right) next_state = WALK_L;
                else               next_state = WALK_R;
            end
            FALL:   next_state = ground ? (state[0] ? WALK_R : WALK_L) : FALL;
            DIG:    next_state = ground ? DIG : FALL;
            default: next_state = WALK_L;
        endcase
    end
    
    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_L;
        end else begin
            state <= next_state;
        end
    end
    
    // Output logic
    assign walk_left = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);
    
endmodule