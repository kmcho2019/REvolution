module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);
    // State encoding:
    // bit1 = falling (1) / walking (0)
    // bit0 = direction: 0 = left, 1 = right
    // States:
    // 2'b00 = walk_left
    // 2'b01 = walk_right
    // 2'b10 = fall_left
    // 2'b11 = fall_right

    reg [1:0] state, next_state;

    always @(*) begin
        next_state = state;
        if (state[1]) begin
            // Currently falling
            if (ground)
                next_state = {1'b0, state[0]};  // stop falling, keep direction
            else
                next_state = state; // remain falling
        end else begin
            // Currently walking
            if (!ground) begin
                // Ground lost, start falling with current direction
                next_state = {1'b1, state[0]};
            end else begin
                // On ground and walking: respond to bumps
                if (bump_left && bump_right) begin
                    // Flip direction
                    next_state = {1'b0, ~state[0]};
                end else if (bump_left) begin
                    // bump_left: direction -> right (1)
                    next_state = {1'b0, 1'b1};
                end else if (bump_right) begin
                    // bump_right: direction -> left (0)
                    next_state = {1'b0, 1'b0};
                end else begin
                    // No bump: remain same
                    next_state = state;
                end
            end
        end
    end

    // Sequential logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00;  // walk_left
        else
            state <= next_state;
    end

    // Output decoding
    assign aaah       = state[1];
    assign walk_left  = (state == 2'b00);
    assign walk_right = (state == 2'b01);

endmodule