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

    // Combined state encoding [1:0] = main state, [2] = direction
    parameter WALK_LEFT  = 3'b000;
    parameter WALK_RIGHT = 3'b001;
    parameter FALL_LEFT  = 3'b010;
    parameter FALL_RIGHT = 3'b011;
    parameter DIG_LEFT   = 3'b100;
    parameter DIG_RIGHT  = 3'b101;
    
    reg [2:0] state;

    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            case (state)
                WALK_LEFT, WALK_RIGHT: begin
                    if (!ground) begin
                        state <= state[2] ? FALL_RIGHT : FALL_LEFT;
                    end else if (dig) begin
                        state <= state[2] ? DIG_RIGHT : DIG_LEFT;
                    end else if (bump_left && !state[2]) begin
                        state <= WALK_RIGHT;
                    end else if (bump_right && state[2]) begin
                        state <= WALK_LEFT;
                    end
                end
                
                FALL_LEFT, FALL_RIGHT: begin
                    if (ground) begin
                        state <= state[2] ? WALK_RIGHT : WALK_LEFT;
                    end
                end
                
                DIG_LEFT, DIG_RIGHT: begin
                    if (!ground) begin
                        state <= state[2] ? FALL_RIGHT : FALL_LEFT;
                    end
                end
            endcase
        end
    end

    // Output logic - direct state decoding
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = state[1]; // All FALL states have bit[1] set
    assign digging    = state[2] & state[1]; // All DIG states have both bits set

endmodule