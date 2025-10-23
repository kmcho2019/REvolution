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

    // State encoding
    localparam WALK_LEFT  = 3'd0;
    localparam WALK_RIGHT = 3'd1;
    localparam DIG_LEFT   = 3'd2;
    localparam DIG_RIGHT  = 3'd3;
    localparam FALL       = 3'd4;
    localparam SPLATTERED = 3'd5;

    reg [2:0] state, next_state;

    // Direction register used during falling to store previous walking direction
    // 0 = left, 1 = right
    reg fall_direction;

    // Fall duration counter (6 bits to count >20 cycles)
    reg [5:0] fall_counter;

    // State and counter update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 6'd0;
            fall_direction <= 1'b0; // left
        end else begin
            state <= next_state;
            // Manage fall counter
            if (state == FALL)
                fall_counter <= fall_counter + 6'd1;
            else
                fall_counter <= 6'd0;

            // Update fall_direction when entering FALL state
            if ((state != FALL) && (next_state == FALL)) begin
                // Save direction depending on current walking or digging state
                case (state)
                    WALK_LEFT, DIG_LEFT:  fall_direction <= 1'b0;
                    WALK_RIGHT, DIG_RIGHT: fall_direction <= 1'b1;
                    default: fall_direction <= 1'b0; // default to left for safety
                endcase
            end
        end
    end

    // Combinational logic for next state
    always @(*) begin
        next_state = state;

        case (state)
            WALK_LEFT: begin
                if (ground == 1'b0)
                    next_state = FALL;
                else if (dig == 1'b1)
                    next_state = DIG_LEFT;
                else if (bump_left == 1'b1 || bump_right == 1'b1)
                    next_state = WALK_RIGHT;
            end

            WALK_RIGHT: begin
                if (ground == 1'b0)
                    next_state = FALL;
                else if (dig == 1'b1)
                    next_state = DIG_RIGHT;
                else if (bump_left == 1'b1 || bump_right == 1'b1)
                    next_state = WALK_LEFT;
            end

            DIG_LEFT: begin
                if (ground == 1'b0)
                    next_state = FALL;
                // dig input ignored while digging
            end

            DIG_RIGHT: begin
                if (ground == 1'b0)
                    next_state = FALL;
                // dig input ignored while digging
            end

            FALL: begin
                if (ground == 1'b1) begin
                    if (fall_counter > 6'd20)
                        next_state = SPLATTERED;
                    else
                        next_state = fall_direction ? WALK_RIGHT : WALK_LEFT;
                end
                // bumps and dig ignored while falling
            end

            SPLATTERED: begin
                next_state = SPLATTERED;
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // Moore outputs based solely on current state
    always @(*) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case (state)
            WALK_LEFT:  walk_left = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            DIG_LEFT:   digging = 1'b1;
            DIG_RIGHT:  digging = 1'b1;
            FALL:       aaah = 1'b1;
            SPLATTERED: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end
        endcase
    end

endmodule