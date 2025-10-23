module TopModule(
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

localparam WALK = 2'd0,
           FALL = 2'd1,
           DIG  = 2'd2;

// Pack mode and direction into a single 3-bit register:
// bits[2:1] = mode, bit0 = direction (0=left,1=right)
reg [2:0] state, next_state;

wire [1:0] mode = state[2:1];
wire dir       = state[0];

always @(*) begin
    next_state = state; // default hold

    // Priority: fall > dig > bump
    if (mode == WALK) begin
        if (!ground) begin
            // start falling, keep direction
            next_state[2:1] = FALL;
        end else if (dig) begin
            // start digging, keep direction
            next_state[2:1] = DIG;
        end else if (bump_left || bump_right) begin
            // update direction based on bumps
            // bump on both sides or either side switches direction accordingly
            if (bump_left && bump_right)
                next_state[0] = ~dir;
            else if (bump_left)
                next_state[0] = 1'b1; // walk right
            else // bump_right
                next_state[0] = 1'b0; // walk left
        end
    end else if (mode == FALL) begin
        if (ground) begin
            // land and resume walking same direction
            next_state[2:1] = WALK;
        end
    end else if (mode == DIG) begin
        if (!ground) begin
            // fall after digging off edge
            next_state[2:1] = FALL;
        end
    end
end

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= {WALK, 1'b0}; // WALK mode and dir=0 (left)
    else
        state <= next_state;
end

assign walk_left  = (mode == WALK) && (dir == 1'b0);
assign walk_right = (mode == WALK) && (dir == 1'b1);
assign aaah       = (mode == FALL);
assign digging    = (mode == DIG);

endmodule