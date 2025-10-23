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
    // bit1: falling (1) / walking (0)
    // bit0: direction: 0=left, 1=right
    // 00 = walk_left
    // 01 = walk_right
    // 10 = fall_left
    // 11 = fall_right

    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;  // walk_left on reset
        end else begin
            if (state[1] == 1'b0) begin
                // walking
                if (ground == 1'b0) begin
                    // start falling, keep direction
                    state <= {1'b1, state[0]};
                end else if (bump_left || bump_right) begin
                    // flip direction if bumped on either or both sides
                    state <= {1'b0, ~state[0]};
                end
                // else remain in current walking state
            end else begin
                // falling
                if (ground == 1'b1) begin
                    // ground reappeared, resume walking same direction
                    state <= {1'b0, state[0]};
                end
                // else remain falling
            end
        end
    end

    // Moore outputs from state bits
    assign aaah       = state[1];
    assign walk_left  = ~state[1] & ~state[0];
    assign walk_right = ~state[1] &  state[0];

endmodule