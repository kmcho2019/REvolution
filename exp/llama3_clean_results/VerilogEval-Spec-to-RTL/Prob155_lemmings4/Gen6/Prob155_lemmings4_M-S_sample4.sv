module TopModule (
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

enum logic [2:0] {
    WALKING = 3'd0,
    FALLING = 3'd1,
    DIGGING = 3'd2,
    SPLATTERED = 3'd3
} state, next_state;

reg [4:0] fall_counter;
reg direction; // 1 for right, 0 for left
reg is_digging;

always @(*) begin
    walk_left = (state == WALKING && !direction) ? 1'b1 : 1'b0;
    walk_right = (state == WALKING && direction) ? 1'b1 : 1'b0;
    aaah = (state == FALLING) ? 1'b1 : 1'b0;
    digging = is_digging;
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        fall_counter <= 5'd0;
        direction <= 1'b0;
        is_digging <= 1'b0;
    end else begin
        case (state)
            WALKING: begin
                if (!ground) begin
                    next_state <= FALLING;
                    fall_counter <= 5'd1;
                end else if (dig) begin
                    next_state <= DIGGING;
                    is_digging <= 1'b1;
                end else if (bump_left || (bump_right && direction)) begin
                    direction <= 1'b1;
                    next_state <= WALKING;
                end else if (bump_right || (bump_left && !direction)) begin
                    direction <= 1'b0;
                    next_state <= WALKING;
                end else begin
                    next_state <= WALKING;
                end
            end
            FALLING: begin
                fall_counter <= fall_counter + 1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        next_state <= SPLATTERED;
                    end else begin
                        next_state <= WALKING;
                    end
                    fall_counter <= 5'd0;
                end else begin
                    next_state <= FALLING;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    next_state <= FALLING;
                    fall_counter <= 5'd1;
                    is_digging <= 1'b0;
                end else if (!dig) begin
                    next_state <= WALKING;
                    is_digging <= 1'b0;
                end else begin
                    next_state <= DIGGING;
                end
            end
            SPLATTERED: begin
                next_state <= SPLATTERED;
            end
        endcase
        state <= next_state;
    end
end

endmodule