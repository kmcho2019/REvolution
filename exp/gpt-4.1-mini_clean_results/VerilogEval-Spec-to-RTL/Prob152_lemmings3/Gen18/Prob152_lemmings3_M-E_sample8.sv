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

    // State encoding (3 bits):
    // bit 2: direction (0=left,1=right)
    // bit 1,0: mode encoding:
    //   2'b00 = walking
    //   2'b01 = digging
    //   2'b10 = falling
    // States:
    // WLK_LEFT  = 3'b000
    // WLK_RIGHT = 3'b100
    // DIG_LEFT  = 3'b001
    // DIG_RIGHT = 3'b101
    // FAL_LEFT  = 3'b010
    // FAL_RIGHT = 3'b110

    localparam WLK_LEFT  = 3'b000;
    localparam WLK_RIGHT = 3'b100;
    localparam DIG_LEFT  = 3'b001;
    localparam DIG_RIGHT = 3'b101;
    localparam FAL_LEFT  = 3'b010;
    localparam FAL_RIGHT = 3'b110;

    reg [2:0] state, next_state;

    wire direction = state[2];
    wire [1:0] mode = state[1:0];

    always @(*) begin
        next_state = state; // default to hold

        case (mode)
            2'b00: begin // walking
                if (!ground) begin
                    // Start falling in current direction
                    next_state = {direction, 2'b10};
                end else if (dig) begin
                    // Start digging only if ground present
                    next_state = {direction, 2'b01};
                end else if (bump_left || bump_right) begin
                    // On bump, switch direction
                    // If both bumps, switch direction as well
                    if (bump_left && bump_right) begin
                        next_state = {~direction, 2'b00}; // walk other way
                    end else if (bump_left) begin
                        next_state = {1'b1, 2'b00}; // walk right
                    end else begin // bump_right
                        next_state = {1'b0, 2'b00}; // walk left
                    end
                end else begin
                    // continue walking same direction
                    next_state = state;
                end
            end
            2'b01: begin // digging
                if (!ground) begin
                    // ground lost, start falling in same direction
                    next_state = {direction, 2'b10};
                end else begin
                    // continue digging
                    next_state = state;
                end
            end
            2'b10: begin // falling
                if (ground) begin
                    // ground regained, resume walking same direction
                    next_state = {direction, 2'b00};
                end else begin
                    // continue falling
                    next_state = state;
                end
            end
            default: begin
                // Should not occur, default to walking left
                next_state = WLK_LEFT;
            end
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WLK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    assign walk_left  = (mode == 2'b00) && (direction == 1'b0);
    assign walk_right = (mode == 2'b00) && (direction == 1'b1);
    assign digging    = (mode == 2'b01);
    assign aaah       = (mode == 2'b10);

endmodule