module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

// state encoding: 00 - falling, 01 - walking left, 10 - walking right
reg [1:0] state, next_state;

always @(*) begin
    case(state)
        2'b00: begin // falling
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            if (ground) begin
                if (next_state == 2'b01) begin
                    next_state = 2'b01; // resume walking left
                end else if (next_state == 2'b10) begin
                    next_state = 2'b10; // resume walking right
                end else begin
                    next_state = 2'b01; // default to walking left
                end
            end else begin
                next_state = 2'b00; // stay falling
            end
        end
        2'b01: begin // walking left
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            if (bump_left) begin
                next_state = 2'b10; // walk right
            end else if (~ground) begin
                next_state = 2'b00; // falling
                next_state = {1'b0, 1'b1}; // store the current state in the high bit
            end else begin
                next_state = 2'b01; // stay walking left
            end
        end
        2'b10: begin // walking right
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            if (bump_right) begin
                next_state = 2'b01; // walk left
            end else if (~ground) begin
                next_state = 2'b00; // falling
                next_state = {1'b1, 1'b0}; // store the current state in the high bit
            end else begin
                next_state = 2'b10; // stay walking right
            end
        end
        default: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            next_state = 2'b01;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;
    end else begin
        state <= next_state;
    end
end

endmodule