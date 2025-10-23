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

    // State encoding (3 bits): {direction, mode, digging}
    // direction: 0=left, 1=right
    // mode: 0=walk, 1=fall
    // digging: 0=no, 1=yes
    //
    // state[2] = direction
    // state[1] = mode (0=walk,1=fall)
    // state[0] = digging

    reg [2:0] state, next_state;

    wire direction = state[2];
    wire mode = state[1];
    wire digging_reg = state[0];

    always @(*) begin
        next_state = state; // default hold

        if (!ground) begin
            // No ground -> start falling, digging stops
            next_state = {direction, 1'b1, 1'b0};
        end else if (mode) begin
            // was falling, ground restored -> resume walking, no digging
            next_state = {direction, 1'b0, 1'b0};
        end else if (digging_reg) begin
            // digging on ground
            if (!ground) begin
                // fall if ground lost
                next_state = {direction, 1'b1, 1'b0};
            end else begin
                // continue digging
                next_state = state;
            end
        end else begin
            // walking on ground, not digging
            if (dig) begin
                // start digging
                next_state = {direction, 1'b0, 1'b1};
            end else if (bump_left || bump_right) begin
                // bump changes direction (fall/dig off)
                // bump priority: if both bumps, flip direction
                if (bump_left && bump_right)
                    next_state = {~direction, 1'b0, 1'b0};
                else if (bump_left)
                    next_state = {1'b1, 1'b0, 1'b0};
                else // bump_right
                    next_state = {1'b0, 1'b0, 1'b0};
            end else begin
                // continue walking same direction
                next_state = state;
            end
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 3'b000; // walk left, no fall, no dig
        else
            state <= next_state;
    end

    assign walk_left  = (mode == 1'b0) && (direction == 1'b0) && (digging_reg == 1'b0);
    assign walk_right = (mode == 1'b0) && (direction == 1'b1) && (digging_reg == 1'b0);
    assign aaah       = (mode == 1'b1);
    assign digging    = digging_reg;

endmodule