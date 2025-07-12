module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

reg [1:0] state, next_state;
reg prev_direction;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Reset to WALK_LEFT state
        prev_direction <= 1'b0;
    end else begin
        state <= next_state;
        if (state == 2'b10 || state == 2'b11) begin
            prev_direction <= (state == 2'b10) ? prev_direction : (walk_left) ? 1'b0 : 1'b1;
        end else if (state == 2'b00 || state == 2'b01) begin
            prev_direction <= (state == 2'b00) ? 1'b0 : 1'b1;
        end
    end
end

always_comb begin
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        2'b00: begin // WALK_LEFT
            walk_left = 1'b1;
            if (bump_left || bump_right) begin
                next_state = 2'b01;
            end else if (dig) begin
                next_state = 2'b11;
            end else if (!ground) begin
                next_state = 2'b10;
            end
        end
        2'b01: begin // WALK_RIGHT
            walk_right = 1'b1;
            if (bump_left || bump_right) begin
                next_state = 2'b00;
            end else if (dig) begin
                next_state = 2'b11;
            end else if (!ground) begin
                next_state = 2'b10;
            end
        end
        2'b10: begin // FALLING
            aaah = 1'b1;
            if (ground) begin
                next_state = (prev_direction == 1'b0) ? 2'b00 : 2'b01;
            end
        end
        2'b11: begin // DIGGING
            digging = 1'b1;
            if (!ground) begin
                next_state = 2'b10;
            end
        end
    endcase
end

endmodule