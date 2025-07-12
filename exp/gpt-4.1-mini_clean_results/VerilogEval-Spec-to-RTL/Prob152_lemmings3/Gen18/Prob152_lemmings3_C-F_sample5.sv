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

        if (!ground) begin
            // Lose ground: always fall, digging stops
            next_state = {direction, 1'b1};  // fall in current direction
            next_digging = 1'b0;
        end else if (mode == 1'b1) begin
            // Currently falling and ground returns: walk same direction, no digging
            next_state = {direction, 1'b0};
            next_digging = 1'b0;
        end else if (digging_reg) begin
            // Currently digging on ground
            if (!ground) begin
                // ground lost during digging: fall, stop digging
                next_state = {direction, 1'b1};
                next_digging = 1'b0;
            end else begin
                // continue digging
                next_state = state;
                next_digging = 1'b1;
            end
        end else begin
            // Walking on ground, not digging
            if (dig) begin
                // start digging
                next_digging = 1'b1;
                next_state = state;
            end else if (bump_left || bump_right) begin
                // bump causes direction change while walking
                // bump_left and bump_right together also flips direction
                if (bump_left && bump_right) begin
                    next_state = {~direction, 1'b0};
                end else if (bump_left) begin
                    next_state = {1'b1, 1'b0}; // walk right
                end else begin // bump_right only
                    next_state = {1'b0, 1'b0}; // walk left
                end
                next_digging = 1'b0;
            end else begin
                // keep walking same direction and no digging
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

    assign walk_left  = (mode == 1'b0) && (direction == 1'b0) && !digging_reg;
    assign walk_right = (mode == 1'b0) && (direction == 1'b1) && !digging_reg;
    assign aaah       = (mode == 1'b1);
    assign digging    = digging_reg;

endmodule