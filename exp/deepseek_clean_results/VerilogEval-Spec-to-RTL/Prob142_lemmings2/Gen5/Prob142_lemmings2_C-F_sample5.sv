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

    // Optimized state encoding
    parameter WALK_LEFT  = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALL       = 2'b10;
    
    reg [1:0] state, next_state;
    
    // Parallel state transition logic
    always @(*) begin
        case (state)
            WALK_LEFT:  next_state = !ground ? FALL       :
                                    bump_left ? WALK_RIGHT : WALK_LEFT;
            WALK_RIGHT: next_state = !ground ? FALL       :
                                    bump_right ? WALK_LEFT : WALK_RIGHT;
            FALL:       next_state = ground ? state[0] ? WALK_RIGHT : WALK_LEFT : FALL;
            default:    next_state = WALK_LEFT;
        endcase
    end
    
    // State register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) state <= WALK_LEFT;
        else state <= next_state;
    end
    
    // Optimized output logic using state bits
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = state[1];  // MSB indicates falling

endmodule