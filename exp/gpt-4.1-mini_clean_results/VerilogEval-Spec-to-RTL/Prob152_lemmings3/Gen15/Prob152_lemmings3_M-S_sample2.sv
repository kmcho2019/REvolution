module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Mode encoding (2 bits)
    localparam MODE_WALK = 2'd0,
               MODE_FALL = 2'd1,
               MODE_DIG  = 2'd2;

    reg [2:0] state, next_state;
    wire [1:0] mode = state[2:1];
    wire dir = state[0];

    always @(*) begin
        // Default: hold state
        next_state = state;

        if (mode == MODE_WALK) begin
            if (!ground) begin
                // Fall if ground disappears
                next_state = {MODE_FALL, dir};
            end else if (dig) begin
                // Dig if on ground and dig asserted
                next_state = {MODE_DIG, dir};
            end else if (bump_left || bump_right) begin
                // Switch direction if any bump while walking
                next_state = {MODE_WALK, ~dir};
            end
        end else if (mode == MODE_FALL) begin
            if (ground) begin
                // Land and walk same direction
                next_state = {MODE_WALK, dir};
            end
        end else if (mode == MODE_DIG) begin
            if (!ground) begin
                // Stop digging and fall if ground lost
                next_state = {MODE_FALL, dir};
            end
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= {MODE_WALK, 1'b0}; // walk left on reset
        else
            state <= next_state;
    end

    assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule