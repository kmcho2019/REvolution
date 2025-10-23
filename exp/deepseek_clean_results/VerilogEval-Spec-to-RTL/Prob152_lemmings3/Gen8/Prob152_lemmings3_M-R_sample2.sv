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
    parameter DIG_L  = 3'b101;
    parameter DIG_R  = 3'b110;

    reg [2:0] state, next_state;

    // Next state logic (continuous assignments)
    wire fall_condition = !ground;
    wire dig_condition = dig && ground;
    wire bump_condition_L = bump_left && (state == WALK_L);
    wire bump_condition_R = bump_right && (state == WALK_R);

    assign next_state = 
        areset ? WALK_L :
        (state == FALL) ? (ground ? (state[0] ? WALK_L : WALK_R) : FALL) :
        fall_condition ? FALL :
        (state == DIG_L || state == DIG_R) ? (fall_condition ? FALL : state) :
        dig_condition ? (state[0] ? DIG_L : DIG_R) :
        bump_condition_L ? WALK_R :
        bump_condition_R ? WALK_L :
        state;

    // State register
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= WALK_L;
        else
            state <= next_state;
    end

    // Output logic
    assign walk_left = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah = (state == FALL);
    assign digging = (state == DIG_L) || (state == DIG_R);

endmodule