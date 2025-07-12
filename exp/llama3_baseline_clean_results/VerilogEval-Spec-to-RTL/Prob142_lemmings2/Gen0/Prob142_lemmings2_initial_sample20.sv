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

reg [1:0] state;
reg [1:0] next_state;

// State encoding:
// 00: walking_left
// 01: walking_right
// 10: falling_walk_left
// 11: falling_walk_right

always @(*) begin
    case (state)
        2'b00: begin // walking_left
            if (ground == 0) begin
                next_state = 2'b10; // falling_walk_left
            end else if (bump_left == 1) begin
                next_state = 2'b01; // walking_right
            end else if (bump_right == 1) begin
                next_state = 2'b00; // walking_left
            end else begin
                next_state = 2'b00; // walking_left
            end
        end
        2'b01: begin // walking_right
            if (ground == 0) begin
                next_state = 2'b11; // falling_walk_right
            end else if (bump_left == 1) begin
                next_state = 2'b01; // walking_right
            end else if (bump_right == 1) begin
                next_state = 2'b00; // walking_left
            end else begin
                next_state = 2'b01; // walking_right
            end
        end
        2'b10: begin // falling_walk_left
            if (ground == 1) begin
                next_state = 2'b00; // walking_left
            end else begin
                next_state = 2'b10; // falling_walk_left
            end
        end
        2'b11: begin // falling_walk_right
            if (ground == 1) begin
                next_state = 2'b01; // walking_right
            end else begin
                next_state = 2'b11; // falling_walk_right
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset == 1) begin
        state <= 2'b00;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        2'b00: begin // walking_left
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
        end
        2'b01: begin // walking_right
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
        end
        2'b10: begin // falling_walk_left
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
        end
        2'b11: begin // falling_walk_right
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
        end
    endcase
end

endmodule