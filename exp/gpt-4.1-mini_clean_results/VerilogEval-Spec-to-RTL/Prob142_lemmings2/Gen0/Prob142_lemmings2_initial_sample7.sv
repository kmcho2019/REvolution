module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
    );

    // Define states
    typedef enum logic [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10
    } state_t;

    state_t state, next_state;

    // We need to remember walking direction before falling
    state_t walk_before_fall;

    // Asynchronous reset on posedge areset
    // Synchronous state update on clk posedge
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walk_before_fall <= WALK_LEFT;
        end else begin
            state <= next_state;
            if (state != FALLING)
                walk_before_fall <= state;
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        next_state = state;

        case(state)
            WALK_LEFT: begin
                if (ground == 0) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // bump_left or bump_right or both => switch direction
                    next_state = WALK_RIGHT;
                end
            end

            WALK_RIGHT: begin
                if (ground == 0) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end
            end

            FALLING: begin
                // When ground returns, resume previous walking direction
                if (ground == 1) begin
                    next_state = walk_before_fall;
                end
            end
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        case(state)
            WALK_LEFT: begin
                walk_left = 1;
            end
            WALK_RIGHT: begin
                walk_right = 1;
            end
            FALLING: begin
                aaah = 1;
            end
        endcase
    end

endmodule