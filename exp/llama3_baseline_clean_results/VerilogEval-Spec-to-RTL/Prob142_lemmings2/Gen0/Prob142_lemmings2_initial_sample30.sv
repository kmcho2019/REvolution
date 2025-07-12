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

reg [1:0] state; // 2-bit state register
reg [1:0] next_state; // next state

// State encoding:
// 00: walking left, not falling
// 01: walking right, not falling
// 10: walking left, falling
// 11: walking right, falling

// Initial state: walking left, not falling
initial state = 2'b00;

always @(*) begin
    case (state)
        2'b00: begin // walking left, not falling
            if (ground == 0) begin // falling
                next_state = 2'b10; // walking left, falling
            end else if (bump_left == 1) begin // bumped on the left
                next_state = 2'b01; // walking right, not falling
            end else if (bump_right == 1) begin // bumped on the right
                next_state = 2'b00; // walking left, not falling
            end else begin
                next_state = 2'b00; // walking left, not falling
            end
        end
        2'b01: begin // walking right, not falling
            if (ground == 0) begin // falling
                next_state = 2'b11; // walking right, falling
            end else if (bump_left == 1) begin // bumped on the left
                next_state = 2'b01; // walking right, not falling
            end else if (bump_right == 1) begin // bumped on the right
                next_state = 2'b00; // walking left, not falling
            end else begin
                next_state = 2'b01; // walking right, not falling
            end
        end
        2'b10: begin // walking left, falling
            if (ground == 1) begin // not falling
                next_state = 2'b00; // walking left, not falling
            end else begin
                next_state = 2'b10; // walking left, falling
            end
        end
        2'b11: begin // walking right, falling
            if (ground == 1) begin // not falling
                next_state = 2'b01; // walking right, not falling
            end else begin
                next_state = 2'b11; // walking right, falling
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left, not falling
    end else begin
        state <= next_state;
    end
end

assign walk_left = (state == 2'b00 || state == 2'b10)? 1'b1 : 1'b0;
assign walk_right = (state == 2'b01 || state == 2'b11)? 1'b1 : 1'b0;
assign aaah = (state == 2'b10 || state == 2'b11)? 1'b1 : 1'b0;

endmodule