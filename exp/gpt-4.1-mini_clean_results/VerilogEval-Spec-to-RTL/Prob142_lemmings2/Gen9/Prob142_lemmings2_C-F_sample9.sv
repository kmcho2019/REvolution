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
    // bit1: falling (1 = falling, 0 = walking)
    // bit0: direction (0 = left, 1 = right)
    reg [1:0] state;

    // Localparam for clarity
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL_LEFT  = 2'b10;
    localparam FALL_RIGHT = 2'b11;

    wire falling   = state[1];
    wire direction = state[0];

    reg [1:0] next_state;

    always @* begin
        if (falling) begin
            // Falling: stay falling until ground returns
            if (ground)
                next_state = {1'b0, direction}; // land, resume walking with same direction
            else
                next_state = state; // continue falling
        end else begin
            // Walking on ground or about to fall
            if (!ground) begin
                // Ground disappeared, start falling with current direction
                next_state = {1'b1, direction};
            end else begin
                // On ground, update direction if bumped
                if (bump_left || bump_right) begin
                    if (bump_left && bump_right) begin
                        // Both bumps flip direction
                        next_state = {1'b0, ~direction};
                    end else if (bump_left) begin
                        // bump_left sets direction to right
                        next_state = {1'b0, 1'b1};
                    end else /* bump_right only */ begin
                        // bump_right sets direction to left
                        next_state = {1'b0, 1'b0};
                    end
                end else begin
                    // No bumps: keep current state
                    next_state = state;
                end
            end
        end
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT; // reset to walking left
        end else begin
            state <= next_state;
        end
    end

    // Moore outputs based on state
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling & direction;

endmodule