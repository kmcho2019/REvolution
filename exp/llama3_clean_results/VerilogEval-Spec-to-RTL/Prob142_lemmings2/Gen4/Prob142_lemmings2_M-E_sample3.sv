module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg [1:0] state;
reg [1:0] next_state;
reg direction;
reg prev_direction;

always @(*) begin
    case(state)
        2'b00: begin // Walking
            if (ground == 1'b0) begin
                next_state = 2'b10; // Falling
            end else if (bump_left == 1'b1 && bump_right == 1'b1) begin
                next_state = 2'b00; // Walking
                direction = ~direction;
            end else if (bump_left == 1'b1) begin
                next_state = 2'b00; // Walking
                direction = 1'b1;
            end else if (bump_right == 1'b1) begin
                next_state = 2'b00; // Walking
                direction = 1'b0;
            end else begin
                next_state = 2'b00; // Walking
            end
            walk_left = ~direction;
            walk_right = direction;
            aaah = 1'b0;
        end
        2'b10: begin // Falling
            if (ground == 1'b1) begin
                next_state = 2'b00; // Walking
                direction = prev_direction;
            end else begin
                next_state = 2'b10; // Falling
            end
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        default: begin // invalid state, should not happen
            next_state = 2'b00; // default to Walking
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
    endcase

    if (areset == 1'b1) begin
        next_state = 2'b00; // reset to Walking
        direction = 1'b0;
        walk_left = 1'b1;
        walk_right = 1'b0;
        aaah = 1'b0;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        state <= 2'b00; // reset to Walking
        direction <= 1'b0;
        prev_direction <= 1'b0;
    end else begin
        state <= next_state;
        if (state == 2'b10) begin
            prev_direction <= direction;
        end
        direction <= direction;
    end
end

endmodule