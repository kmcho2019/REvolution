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
    // bit1 = falling flag (1 = falling, 0 = walking)
    // bit0 = direction (0 = left, 1 = right)
    // 2'b00 = walking left
    // 2'b01 = walking right
    // 2'b10 = falling left
    // 2'b11 = falling right
    reg [1:0] state, next_state;

    // Combinational next state logic (Moore FSM)
    always @(*) begin
        next_state = state;
        case (state)
            2'b00: begin // walking left
                if (!ground) begin
                    // start falling left, direction preserved
                    next_state = 2'b10;
                end else if (bump_left && bump_right) begin
                    // bumped both sides, flip direction to right
                    next_state = 2'b01;
                end else if (bump_left) begin
                    // bumped left, turn right
                    next_state = 2'b01;
                end else if (bump_right) begin
                    // bumped right, stay walking left (no direction change)
                    next_state = 2'b00;
                end else begin
                    next_state = 2'b00;
                end
            end

            2'b01: begin // walking right
                if (!ground) begin
                    // start falling right, direction preserved
                    next_state = 2'b11;
                end else if (bump_left && bump_right) begin
                    // bumped both sides, flip direction to left
                    next_state = 2'b00;
                end else if (bump_left) begin
                    // bumped left, stay walking right
                    next_state = 2'b01;
                end else if (bump_right) begin
                    // bumped right, turn left
                    next_state = 2'b00;
                end else begin
                    next_state = 2'b01;
                end
            end

            2'b10: begin // falling left
                if (ground) begin
                    // landed, resume walking left
                    next_state = 2'b00;
                end else begin
                    // keep falling left
                    next_state = 2'b10;
                end
            end

            2'b11: begin // falling right
                if (ground) begin
                    // landed, resume walking right
                    next_state = 2'b01;
                end else begin
                    // keep falling right
                    next_state = 2'b11;
                end
            end

            default: next_state = 2'b00; // safe default to walking left
        endcase
    end

    // Sequential state register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00; // start walking left
        end else begin
            state <= next_state;
        end
    end

    // Moore outputs decoded from state bits
    assign aaah       = state[1];             // falling flag
    assign walk_left  = (state[1] == 1'b0) && (state[0] == 1'b0);
    assign walk_right = (state[1] == 1'b0) && (state[0] == 1'b1);

endmodule