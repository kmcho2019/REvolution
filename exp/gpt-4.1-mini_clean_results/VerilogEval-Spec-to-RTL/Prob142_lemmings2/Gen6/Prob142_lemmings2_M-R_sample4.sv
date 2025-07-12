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

    // State encoding: [falling_direction]
    // bit 1 = falling (1 = falling, 0 = walking)
    // bit 0 = direction (0 = left, 1 = right)
    localparam WALK_LEFT  = 2'b00,
               WALK_RIGHT = 2'b01,
               FALL_LEFT  = 2'b10,
               FALL_RIGHT = 2'b11;

    reg [1:0] state, next_state;

    // Combinational next-state logic
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALL_LEFT;
                end else if (bump_left && bump_right) begin
                    // Both bumps: flip direction -> walk_right
                    next_state = WALK_RIGHT;
                end else if (bump_left) begin
                    // bump_left causes walk right
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    // bump_right causes walk left (already walking left)
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                end else if (bump_left && bump_right) begin
                    // Both bumps: flip direction -> walk_left
                    next_state = WALK_LEFT;
                end else if (bump_left) begin
                    // bump_left causes walk right (already walking right)
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    // bump_right causes walk left
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            FALL_LEFT: begin
                if (ground) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = FALL_LEFT;
                end
            end

            FALL_RIGHT: begin
                if (ground) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = FALL_RIGHT;
                end
            end

            default: next_state = WALK_LEFT; // Safe default
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Output logic (Moore): only one output asserted at a time
    assign aaah       = state[1];          // falling if MSB=1
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule