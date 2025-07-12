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

    // State encoding
    localparam [1:0]
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10;

    reg [1:0] state, next_state;

    // Store last walking direction to resume after falling
    reg last_direction; // 0=left, 1=right

    // Combinational next state logic
    always @(*) begin
        next_state = state;

        case(state)
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALLING; // start falling
                else if (bump_left || bump_right) begin
                    // Both bumps or one bump?
                    if (bump_left && bump_right)
                        next_state = WALK_RIGHT; // flip direction
                    else if (bump_left)
                        next_state = WALK_RIGHT;
                    else if (bump_right)
                        next_state = WALK_LEFT; // redundant but explicit
                end
            end

            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALLING; // start falling
                else if (bump_left || bump_right) begin
                    if (bump_left && bump_right)
                        next_state = WALK_LEFT; // flip direction
                    else if (bump_left)
                        next_state = WALK_RIGHT; // redundant but explicit
                    else if (bump_right)
                        next_state = WALK_LEFT;
                end
            end

            FALLING: begin
                if (ground) begin
                    // Resume last walking direction
                    next_state = last_direction ? WALK_RIGHT : WALK_LEFT;
                end
                // bumps ignored during falling
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            last_direction <= 1'b0;
        end else begin
            // Update last_direction only if walking
            if (state == WALK_LEFT)
                last_direction <= 1'b0;
            else if (state == WALK_RIGHT)
                last_direction <= 1'b1;

            state <= next_state;
        end
    end

    // Output decoding (Moore outputs)
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);

endmodule