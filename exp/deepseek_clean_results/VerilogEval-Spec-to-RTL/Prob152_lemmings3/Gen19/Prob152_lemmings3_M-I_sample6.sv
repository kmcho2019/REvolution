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

    // One-hot encoded states
    parameter WALK_LEFT  = 4'b0001;
    parameter WALK_RIGHT = 4'b0010;
    parameter DIG_LEFT   = 4'b0100;
    parameter DIG_RIGHT  = 4'b1000;
    parameter FALL       = 4'b0000; // All zeros for fall state

    reg [3:0] state;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end
        else begin
            case (state)
                WALK_LEFT: begin
                    if (!ground) state <= FALL;
                    else if (dig) state <= DIG_LEFT;
                    else if (bump_left) state <= WALK_RIGHT;
                end
                
                WALK_RIGHT: begin
                    if (!ground) state <= FALL;
                    else if (dig) state <= DIG_RIGHT;
                    else if (bump_right) state <= WALK_LEFT;
                end
                
                DIG_LEFT: begin
                    if (!ground) state <= FALL;
                end
                
                DIG_RIGHT: begin
                    if (!ground) state <= FALL;
                end
                
                FALL: begin
                    if (ground) begin
                        case (state)
                            DIG_LEFT: state <= WALK_LEFT;
                            DIG_RIGHT: state <= WALK_RIGHT;
                            default: state <= (state == WALK_RIGHT) ? WALK_RIGHT : WALK_LEFT;
                        endcase
                    end
                end
            endcase
        end
    end

    // Output logic - direct from state bits
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG_LEFT) | (state == DIG_RIGHT);

endmodule