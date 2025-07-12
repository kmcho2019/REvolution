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

    // State encoding (2 bits)
    // 00: walking left
    // 01: walking right
    // 10: falling left
    // 11: falling right
    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        next_state = state; // default hold state

        case(state)
            2'b00: begin // walking left
                if (!ground)
                    next_state = 2'b10; // start falling left
                else if (bump_left || bump_right) begin
                    // bump on left or right flips to walking right
                    // bump on both sides or either flips direction to right
                    next_state = 2'b01;
                end
                // else remain walking left
            end
            2'b01: begin // walking right
                if (!ground)
                    next_state = 2'b11; // start falling right
                else if (bump_left || bump_right) begin
                    // bump on left or right flips to walking left
                    next_state = 2'b00;
                end
                // else remain walking right
            end
            2'b10: begin // falling left
                if (ground)
                    next_state = 2'b00; // ground reappeared, walk left
                // else remain falling left
            end
            2'b11: begin // falling right
                if (ground)
                    next_state = 2'b01; // ground reappeared, walk right
                // else remain falling right
            end
            default: next_state = 2'b00; // safety reset to walking left
        endcase
    end

    // Asynchronous reset, synchronous state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // walking left
        else
            state <= next_state;
    end

    // Moore outputs
    assign aaah       = (state[1]);         // top bit set means falling
    assign walk_left  = (state == 2'b00);
    assign walk_right = (state == 2'b01);

endmodule