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
    // 2'b00: walk_left
    // 2'b01: walk_right
    // 2'b10: fall_left
    // 2'b11: fall_right
    reg [1:0] state, next_state;

    always @(*) begin
        next_state = state;
        case(state)
            2'b00: begin // walk_left
                if (!ground)
                    next_state = 2'b10; // fall_left
                else if (bump_left || bump_right)
                    next_state = 2'b01; // walk_right
            end
            2'b01: begin // walk_right
                if (!ground)
                    next_state = 2'b11; // fall_right
                else if (bump_left || bump_right)
                    next_state = 2'b00; // walk_left
            end
            2'b10: begin // fall_left
                if (ground)
                    next_state = 2'b00; // walk_left
            end
            2'b11: begin // fall_right
                if (ground)
                    next_state = 2'b01; // walk_right
            end
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // reset to walk_left
        else
            state <= next_state;
    end

    assign walk_left  = (state == 2'b00);
    assign walk_right = (state == 2'b01);
    assign aaah       = (state[1] == 1'b1); // falling states: 10 or 11

endmodule