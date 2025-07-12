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
    // Combined state and direction encoding
    parameter WALK_LEFT = 3'b000;
    parameter WALK_RIGHT = 3'b001;
    parameter FALL = 3'b010;
    parameter DIG_LEFT = 3'b100;
    parameter DIG_RIGHT = 3'b101;
    
    reg [2:0] state, next_state;
    
    // State transition logic
    always @(*) begin
        case (state)
            WALK_LEFT, WALK_RIGHT: begin
                if (~ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = state[0] ? DIG_RIGHT : DIG_LEFT;
                end else if ((state == WALK_LEFT && bump_left) || 
                            (state == WALK_RIGHT && bump_right)) begin
                    next_state = state ^ 3'b001; // Toggle direction
                end else begin
                    next_state = state;
                end
            end
            FALL: begin
                next_state = ground ? (state[1] ? WALK_RIGHT : WALK_LEFT) : FALL;
            end
            DIG_LEFT, DIG_RIGHT: begin
                next_state = ground ? state : FALL;
            end
            default: next_state = WALK_LEFT;
        endcase
    end
    
    // State register with async reset
    always @(posedge clk or posedge areset) begin
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
    assign digging = (state[2]);
    
endmodule