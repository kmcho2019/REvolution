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

    // State transition signals
    wire to_fall = (state == WALK && !ground) || (state == DIG && !ground);
    wire to_walk = (state == FALL && ground);
    wire to_dig  = (state == WALK && ground && dig);

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
        end else begin
            case (1'b1)
                to_fall: state <= FALL;
                to_walk: state <= WALK;
                to_dig:  state <= DIG;
                default: state <= state;
            endcase
        end
    end

    // Direction logic (separate always block)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 0;
        end else if (state == WALK && ground && !dig && (bump_left || bump_right)) begin
            direction <= bump_left;
        end
    end

    // Output assignments
    assign walk_left  = (state == WALK) & ~direction;
    assign walk_right = (state == WALK) & direction;
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule