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
    // bit 1: falling (0 = walking, 1 = falling)
    // bit 0: direction (0 = left, 1 = right)
    reg [1:0] state, next_state;

    wire bump = bump_left | bump_right;

    // Next state logic combinational
    always @(*) begin
        next_state = state; // default: hold state
        case (state)
            2'b00: begin // walking left
                if (!ground)
                    next_state = 2'b10; // start falling, direction preserved (left)
                else if (bump) begin
                    // switch direction to right
                    next_state = 2'b01;
                end
            end
            2'b01: begin // walking right
                if (!ground)
                    next_state = 2'b11; // start falling, direction preserved (right)
                else if (bump) begin
                    // switch direction to left
                    next_state = 2'b00;
                end
            end
            2'b10: begin // falling left
                if (ground)
                    next_state = 2'b00; // stop falling, resume walking left
            end
            2'b11: begin // falling right
                if (ground)
                    next_state = 2'b01; // stop falling, resume walking right
            end
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // walk left and not falling on reset
        else
            state <= next_state;
    end

    assign walk_left  = (state == 2'b00);
    assign walk_right = (state == 2'b01);
    assign aaah       = state[1]; // falling bit

endmodule