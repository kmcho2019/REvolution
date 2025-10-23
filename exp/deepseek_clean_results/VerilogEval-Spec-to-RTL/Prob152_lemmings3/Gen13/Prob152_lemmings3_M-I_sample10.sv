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
    parameter WALK = 3'b001;
    parameter FALL = 3'b010;
    parameter DIG  = 3'b100;

    reg [2:0] state;
    reg direction; // 0=left, 1=right
    wire bump = bump_left | bump_right;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
        end
        else begin
            case (state)
                WALK: begin
                    if (!ground)      state <= FALL;
                    else if (dig)     state <= DIG;
                    else              state <= WALK;
                end
                
                FALL: state <= ground ? WALK : FALL;
                
                DIG:  state <= ground ? DIG : FALL;
                
                default: state <= WALK;
            endcase
        end
    end

    // Direction update (separate for better timing)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 0;
        end
        else if (state == WALK && ground && !dig && bump) begin
            direction <= bump_left;
        end
    end

    // Output logic - direct from state and direction
    assign walk_left  = (state == WALK) & ~direction;
    assign walk_right = (state == WALK) &  direction;
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule