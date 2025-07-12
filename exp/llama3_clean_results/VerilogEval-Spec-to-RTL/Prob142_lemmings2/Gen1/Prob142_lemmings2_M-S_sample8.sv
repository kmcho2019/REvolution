module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state; // WL: 2'b00, WR: 2'b01, F: 2'b10
reg direction; // 1'b0: left, 1'b1: right
reg walk_left_reg, walk_right_reg, aaah_reg;

always @(*) begin
    walk_left_reg = 1'b0;
    walk_right_reg = 1'b0;
    aaah_reg = 1'b0;
    
    case(state)
        2'b00: begin // Walking Left
            walk_left_reg = 1'b1;
            if (bump_left == 1'b1) begin
                direction = 1'b1; // switch to right
            end else if (bump_right == 1'b1) begin
                // do nothing, keep walking left
            end
            if (ground == 1'b0) begin
                state = 2'b10; // Falling
            end else if (bump_left == 1'b1) begin
                state = 2'b01; // switch to Walking Right
            end
        end
        2'b01: begin // Walking Right
            walk_right_reg = 1'b1;
            if (bump_right == 1'b1) begin
                direction = 1'b0; // switch to left
            end else if (bump_left == 1'b1) begin
                // do nothing, keep walking right
            end
            if (ground == 1'b0) begin
                state = 2'b10; // Falling
            end else if (bump_right == 1'b1) begin
                state = 2'b00; // switch to Walking Left
            end
        end
        2'b10: begin // Falling
            aaah_reg = 1'b1;
            if (ground == 1'b1) begin
                if (direction == 1'b0) begin
                    state = 2'b00; // switch to Walking Left
                end else begin
                    state = 2'b01; // switch to Walking Right
                end
            end
        end
        default: begin // invalid state, should not happen
            state = 2'b00; // default to Walking Left
        end
    endcase
    
    if (areset == 1'b1) begin
        state = 2'b00; // reset to Walking Left
        direction = 1'b0; // reset direction to left
    end
end

always @(posedge clk) begin
    walk_left <= walk_left_reg;
    walk_right <= walk_right_reg;
    aaah <= aaah_reg;
    state <= state;
    direction <= direction;
end

initial begin
    state = 2'b00;
    direction = 1'b0;
end

endmodule