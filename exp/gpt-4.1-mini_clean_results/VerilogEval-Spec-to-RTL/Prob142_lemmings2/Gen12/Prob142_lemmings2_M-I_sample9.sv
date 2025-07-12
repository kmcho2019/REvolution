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
    // bit1 (falling): 0 = walking, 1 = falling
    // bit0 (direction): 0 = left, 1 = right
    reg [1:0] state;

    reg [1:0] next_state;

    always @* begin
        case (state)
            2'b00: begin // walking left
                if (!ground)
                    next_state = 2'b10; // falling left
                else if (bump_left && bump_right)
                    next_state = 2'b01; // flip direction walking right
                else if (bump_left)
                    next_state = 2'b01; // bump left => walk right
                else if (bump_right)
                    next_state = 2'b00; // bump right => walk left (already walking left)
                else
                    next_state = state;
            end
            2'b01: begin // walking right
                if (!ground)
                    next_state = 2'b11; // falling right
                else if (bump_left && bump_right)
                    next_state = 2'b00; // flip direction walking left
                else if (bump_left)
                    next_state = 2'b01; // bump left => walk right (already walking right)
                else if (bump_right)
                    next_state = 2'b00; // bump right => walk left
                else
                    next_state = state;
            end
            2'b10: begin // falling left
                if (ground)
                    next_state = 2'b00; // ground returns, resume walking left
                else
                    next_state = state; // keep falling
            end
            2'b11: begin // falling right
                if (ground)
                    next_state = 2'b01; // ground returns, resume walking right
                else
                    next_state = state; // keep falling
            end
            default: next_state = 2'b00; // default to walking left
        endcase
    end

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (areset) begin
            state <= 2'b00; // reset to walking left
        end else begin
            state <= next_state;
        end
    end

    // Outputs (Moore machine)
    assign aaah       = state[1];         // falling bit
    assign walk_left  = (~state[1]) & (~state[0]);
    assign walk_right = (~state[1]) & state[0];

endmodule