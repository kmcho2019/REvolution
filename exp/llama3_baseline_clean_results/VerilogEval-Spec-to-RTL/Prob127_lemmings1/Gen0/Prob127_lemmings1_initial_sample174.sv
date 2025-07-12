module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

reg [1:0] state; // 0: walking_left, 1: walking_right
reg [1:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Reset to walking_left state
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        2'b00: begin // walking_left
            if (bump_left) begin
                next_state = 2'b01; // Switch to walking_right
            end else if (bump_right) begin
                next_state = 2'b01; // Switch to walking_right
            end else begin
                next_state = 2'b00; // Stay in walking_left state
            end
        end
        2'b01: begin // walking_right
            if (bump_right) begin
                next_state = 2'b00; // Switch to walking_left
            end else if (bump_left) begin
                next_state = 2'b00; // Switch to walking_left
            end else begin
                next_state = 2'b01; // Stay in walking_right state
            end
        end
        default: begin
            next_state = 2'b00; // Default to walking_left state
        end
    endcase
end

assign walk_left = (state == 2'b00);
assign walk_right = (state == 2'b01);

endmodule