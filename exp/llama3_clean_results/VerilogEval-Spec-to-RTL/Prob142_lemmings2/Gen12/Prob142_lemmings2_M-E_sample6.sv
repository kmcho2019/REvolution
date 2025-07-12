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

reg [1:0] state; // 2 bits to represent the state (00: walking left, 01: walking right, 10: falling)
reg [1:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        2'b00: // walking left
            begin
                if (~ground) begin
                    next_state = 2'b10; // falling
                end else if (bump_left) begin
                    next_state = 2'b01; // walking right
                end else if (bump_right) begin
                    next_state = 2'b00; // keep walking left
                end else begin
                    next_state = 2'b00; // keep walking left
                end
            end
        2'b01: // walking right
            begin
                if (~ground) begin
                    next_state = 2'b10; // falling
                end else if (bump_right) begin
                    next_state = 2'b00; // walking left
                end else if (bump_left) begin
                    next_state = 2'b01; // keep walking right
                end else begin
                    next_state = 2'b01; // keep walking right
                end
            end
        2'b10: // falling
            begin
                if (ground) begin
                    next_state = state; // resume walking in the same direction
                end else begin
                    next_state = 2'b10; // keep falling
                end
            end
    endcase
end

// Output logic
always @(posedge clk) begin
    if (state == 2'b00) begin
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
    end else if (state == 2'b01) begin
        walk_left <= 1'b0;
        walk_right <= 1'b1;
        aaah <= 1'b0;
    end else if (state == 2'b10) begin
        walk_left <= 1'b0;
        walk_right <= 1'b0;
        aaah <= 1'b1;
    end
end

endmodule