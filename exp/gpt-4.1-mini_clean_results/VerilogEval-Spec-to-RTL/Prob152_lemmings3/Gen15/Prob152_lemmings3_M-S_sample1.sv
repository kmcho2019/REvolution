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

    // State encoding:
    // state[1]: mode (0=walk,1=fall/dig)
    // state[0]: direction (0=left,1=right)
    reg [1:0] state, next_state;
    reg digging_reg, next_digging;

    wire mode = state[1];
    wire dir  = state[0];

    // Next state logic
    always @(*) begin
        // default: hold current state
        next_state = state;
        next_digging = digging_reg;

        if (mode == 1'b0) begin
            // Walking mode
            if (!ground) begin
                // Ground lost: start falling, no digging
                next_state = {1'b1, dir};
                next_digging = 1'b0;
            end else if (dig) begin
                // Start digging
                next_state = {1'b1, dir};
                next_digging = 1'b1;
            end else if (bump_left && bump_right) begin
                // Both bumps: reverse direction
                next_state = {1'b0, ~dir};
            end else if (bump_left) begin
                // bump left -> walk right
                next_state = {1'b0, 1'b1};
            end else if (bump_right) begin
                // bump right -> walk left
                next_state = {1'b0, 1'b0};
            end
            // else stay
        end else begin
            // Falling or digging
            if (ground) begin
                // Land: walk same direction, stop digging
                next_state = {1'b0, dir};
                next_digging = 1'b0;
            end else if (digging_reg && !ground) begin
                // Digging and ground lost -> start falling
                next_state = {1'b1, dir};
                next_digging = 1'b0;
            end
            // else hold
        end
    end

    // Sequential update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;       // walk left
            digging_reg <= 1'b0;
        end else begin
            state <= next_state;
            digging_reg <= next_digging;
        end
    end

    // Moore outputs
    assign walk_left  = (mode == 1'b0) && (dir == 1'b0);
    assign walk_right = (mode == 1'b0) && (dir == 1'b1);
    assign aaah       = (mode == 1'b1) && (digging_reg == 1'b0);
    assign digging    = (mode == 1'b1) && (digging_reg == 1'b1);

endmodule