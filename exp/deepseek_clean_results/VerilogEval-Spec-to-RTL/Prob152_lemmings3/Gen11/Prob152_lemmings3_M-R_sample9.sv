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

    // State transitions (combinational)
    wire [2:0] next_state;
    assign next_state = 
        (areset) ? WALK :
        (state == WALK) ? 
            (!ground ? FALL : 
             (dig ? DIG : WALK)) :
        (state == FALL) ? 
            (ground ? WALK : FALL) :
        (state == DIG) ? 
            (!ground ? FALL : DIG) :
        WALK; // default

    // Direction update (combinational)
    wire next_direction;
    assign next_direction = 
        (areset) ? 0 :
        (state == WALK && ground && !dig && !(!ground)) ? 
            (bump_left ? 1 : 
             (bump_right ? 0 : direction)) :
        direction;

    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;
        end else begin
            state <= next_state;
            direction <= next_direction;
        end
    end

    // Outputs
    assign walk_left = (state == WALK) & ~direction;
    assign walk_right = (state == WALK) & direction;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule