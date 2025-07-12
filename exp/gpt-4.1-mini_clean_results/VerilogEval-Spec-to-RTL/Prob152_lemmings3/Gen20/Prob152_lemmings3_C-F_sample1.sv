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

    // State encoding (2 bits):
    // bit 1: direction (0=left,1=right)
    // bit 0: mode (0=walk,1=fall)
    localparam WLK_LEFT  = 2'b00;
    localparam WLK_RIGHT = 2'b10;
    localparam FAL_LEFT  = 2'b01;
    localparam FAL_RIGHT = 2'b11;

    reg [1:0] state, next_state;
    reg digging_reg, next_digging;

    wire direction = state[1];
    wire mode      = state[0]; // 0=walk,1=fall

    always @(*) begin
        // Default next state and digging keep current values
        next_state = state;
        next_digging = digging_reg;

        // Priority 1: Fall if no ground - digging stops immediately
        if (!ground) begin
            next_state = {direction, 1'b1};  // fall in current direction
            next_digging = 1'b0;

        // Priority 2: If falling and ground returns, resume walking and no digging
        end else if (mode == 1'b1) begin
            next_state = {direction, 1'b0};
            next_digging = 1'b0;

        // Priority 3: If digging and ground present, continue digging,
        // else if ground lost during digging (already handled above)
        end else if (digging_reg) begin
            next_state = state;
            next_digging = 1'b1;

        // Priority 4: Walking on ground and not digging
        end else begin
            if (dig) begin
                // Start digging
                next_digging = 1'b1;
                next_state = state;
            end else if (bump_left || bump_right) begin
                // Change direction on bump - bump_left and bump_right together flips direction
                if (bump_left && bump_right) begin
                    next_state = {~direction, 1'b0};
                end else if (bump_left) begin
                    next_state = {1'b1, 1'b0}; // walk right
                end else begin // bump_right only
                    next_state = {1'b0, 1'b0}; // walk left
                end
                next_digging = 1'b0;
            end else begin
                // Continue walking same direction, no digging
                next_state = state;
                next_digging = 1'b0;
            end
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WLK_LEFT;
            digging_reg <= 1'b0;
        end else begin
            state <= next_state;
            digging_reg <= next_digging;
        end
    end

    // Moore outputs derived from state and digging flag
    assign walk_left  = (mode == 1'b0) && (direction == 1'b0) && !digging_reg;
    assign walk_right = (mode == 1'b0) && (direction == 1'b1) && !digging_reg;
    assign aaah       = (mode == 1'b1);
    assign digging    = digging_reg;

endmodule