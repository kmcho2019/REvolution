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
    // Combined state encoding: [1:0] action, [2] direction (0=left, 1=right)
    parameter WALK_L = 3'b000;
    parameter WALK_R = 3'b001;
    parameter FALL_L = 3'b010;
    parameter FALL_R = 3'b011;
    parameter DIG_L  = 3'b100;
    parameter DIG_R  = 3'b101;
    
    reg [2:0] state, next_state;
    
    // State transitions
    always @(*) begin
        case (state)
            WALK_L, WALK_R: begin
                if (~ground) begin
                    next_state = state[2] ? FALL_R : FALL_L;
                end else if (dig) begin
                    next_state = state[2] ? DIG_R : DIG_L;
                end else if ((bump_left && ~state[2]) || (bump_right && state[2])) begin
                    next_state = state[2] ? WALK_L : WALK_R;
                end else begin
                    next_state = state;
                end
            end
            
            FALL_L, FALL_R: begin
                next_state = ground ? (state[2] ? WALK_R : WALK_L) : state;
            end
            
            DIG_L, DIG_R: begin
                next_state = ~ground ? (state[2] ? FALL_R : FALL_L) : state;
            end
            
            default: next_state = WALK_L;
        endcase
    end
    
    // State update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_L;
        end else begin
            state <= next_state;
        end
    end
    
    // Output logic
    assign walk_left  = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah       = (state == FALL_L) || (state == FALL_R);
    assign digging    = (state == DIG_L) || (state == DIG_R);
    
endmodule