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

    // State encoding using localparams
    localparam WALK_LEFT  = 3'd0;
    localparam WALK_RIGHT = 3'd1;
    localparam FALLING    = 3'd2;
    localparam DIGGING    = 3'd3;
    localparam SPLATTERED = 3'd4;

    reg [2:0] state, next_state;

    // Keep track of original walking direction before falling
    // 0 = left, 1 = right
    reg direction_before_fall;

    // Fall duration counter (6 bits to count >20)
    reg [5:0] fall_counter;

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 6'd0;
            direction_before_fall <= 1'b0; // walking left
        end else begin
            state <= next_state;

            if (state == FALLING) begin
                fall_counter <= fall_counter + 6'd1;
            end else begin
                fall_counter <= 6'd0;
            end

            // Remember direction before fall only on transition from walking or digging to falling
            if ((state == WALK_LEFT || state == WALK_RIGHT || state == DIGGING)
                && next_state == FALLING) begin
                direction_before_fall <= (state == WALK_RIGHT) ? 1'b1 : 1'b0;
            end
        end
    end

    // Combinational logic to determine next state
    always @(*) begin
        // Default next state is current state
        next_state = state;

        case(state)
            WALK_LEFT: begin
                // Precedence: fall > dig > bump
                if (ground == 1'b0) begin
                    next_state = FALLING;
                end else if (dig == 1'b1) begin
                    next_state = DIGGING;
                end else if (bump_left == 1'b1 || bump_right == 1'b1) begin
                    // Switch direction on bump (both or either)
                    next_state = WALK_RIGHT;
                end
            end

            WALK_RIGHT: begin
                if (ground == 1'b0) begin
                    next_state = FALLING;
                end else if (dig == 1'b1) begin
                    next_state = DIGGING;
                end else if (bump_left == 1'b1 || bump_right == 1'b1) begin
                    // Switch direction on bump
                    next_state = WALK_LEFT;
                end
            end

            DIGGING: begin
                // Continue digging if ground == 1, else start falling
                if (ground == 1'b0) begin
                    next_state = FALLING;
                end
                // dig input ignored while digging
            end

            FALLING: begin
                if (ground == 1'b1) begin
                    if (fall_counter > 6'd20) begin
                        next_state = SPLATTERED;
                    end else begin
                        // Return to walking in original direction before falling
                        next_state = direction_before_fall ? WALK_RIGHT : WALK_LEFT;
                    end
                end
                // bumps and dig ignored while falling
            end

            SPLATTERED: begin
                // Remain splattered forever until reset
                next_state = SPLATTERED;
            end

            default: begin
                next_state = WALK_LEFT; // Default safety
            end
        endcase
    end

    // Moore outputs: determined solely by current state
    always @(*) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case(state)
            WALK_LEFT: walk_left = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            FALLING: aaah = 1'b1;
            DIGGING: digging = 1'b1;
            SPLATTERED: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end
        endcase
    end

endmodule