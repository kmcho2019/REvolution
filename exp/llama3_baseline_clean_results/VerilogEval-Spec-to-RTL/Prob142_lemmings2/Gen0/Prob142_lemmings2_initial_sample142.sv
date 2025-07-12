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

reg [1:0] state, next_state;

// encoding:
// 2'b00: walking left
// 2'b01: walking right
// 2'b10: falling

always @(*) begin
    case(state)
        2'b00: begin // walking left
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            if (ground == 1'b0) begin
                next_state = 2'b10;
            end else if (bump_left == 1'b1) begin
                next_state = 2'b01;
            end else if (bump_right == 1'b1) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b01: begin // walking right
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            if (ground == 1'b0) begin
                next_state = 2'b10;
            end else if (bump_left == 1'b1) begin
                next_state = 2'b00;
            end else if (bump_right == 1'b1) begin
                next_state = 2'b00;
            end else begin
                next_state = 2'b01;
            end
        end
        2'b10: begin // falling
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            if (ground == 1'b1) begin
                if (state == 2'b00) begin
                    next_state = 2'b00;
                end else begin
                    next_state = 2'b01;
                end
            end else begin
                next_state = 2'b10;
            end
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            next_state = 2'b00;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
    end else begin
        state <= next_state;
    end
end

endmodule