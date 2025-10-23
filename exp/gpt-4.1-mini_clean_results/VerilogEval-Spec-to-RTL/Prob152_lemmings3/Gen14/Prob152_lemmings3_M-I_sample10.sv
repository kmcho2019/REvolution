module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
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
    wire walking = (mode == 1'b0);

    // Next state and digging logic
    always @(*) begin
        next_state = state;
        next_digging = digging_reg;

        if (!ground) begin
            // No ground: fall regardless, digging stops
            next_state = {direction, 1'b1}; // fall in current direction
            next_digging = 1'b0;
        end else if (mode == 1'b1) begin
            // Falling and ground back: walk same direction, no dig
            next_state = {direction, 1'b0};
            next_digging = 1'b0;
        end else begin
            // Walking on ground
            if (digging_reg) begin
                // Currently digging and ground present
                // If ground lost, start falling; else keep digging
                // ground lost case handled above, so here ground=1
                next_state = state;
                next_digging = 1'b1;
            end else begin
                // Not digging
                if (dig) begin
                    // Start digging if dig=1 and walking
                    next_state = state;
                    next_digging = 1'b1;
                end else if (bump_left || bump_right) begin
                    // switch direction on bump while walking
                    if (bump_left && bump_right)
                        next_state = {~direction, 1'b0};
                    else if (bump_left)
                        next_state = {1'b1, 1'b0}; // walk right
                    else
                        next_state = {1'b0, 1'b0}; // walk left
                    next_digging = 1'b0;
                end else begin
                    next_state = state;
                    next_digging = 1'b0;
                end
            end
        end
    end

    // Update registers with minimal toggling on digging_reg
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WLK_LEFT;
            digging_reg <= 1'b0;
        end else begin
            state <= (next_state != state) ? next_state : state;
            if (next_digging != digging_reg)
                digging_reg <= next_digging;
        end
    end

    // Registered outputs for improved timing and glitch reduction
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
        end else begin
            walk_left <= (mode == 1'b0) && (direction == 1'b0) && !digging_reg;
            walk_right <= (mode == 1'b0) && (direction == 1'b1) && !digging_reg;
            aaah <= (mode == 1'b1);
            digging <= digging_reg;
        end
    end

endmodule