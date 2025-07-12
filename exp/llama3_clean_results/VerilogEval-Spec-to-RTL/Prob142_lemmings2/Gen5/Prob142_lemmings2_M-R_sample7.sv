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

always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        state <= 2'b00; // reset to Walking Left
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        2'b00: begin // Walking Left
            if (ground == 1'b0) begin
                next_state = 2'b10; // Falling
            end else if (bump_left == 1'b1 || bump_right == 1'b1) begin
                next_state = 2'b01; // Walking Right
            end else begin
                next_state = 2'b00; // Still Walking Left
            end
        end
        2'b01: begin // Walking Right
            if (ground == 1'b0) begin
                next_state = 2'b10; // Falling
            end else if (bump_left == 1'b1 || bump_right == 1'b1) begin
                next_state = 2'b00; // Walking Left
            end else begin
                next_state = 2'b01; // Still Walking Right
            end
        end
        2'b10: begin // Falling
            if (ground == 1'b1) begin
                next_state = (state[0] == 1'b0)? 2'b00 : 2'b01; // Resume walking
            end else begin
                next_state = 2'b10; // Still Falling
            end
        end
        default: begin // invalid state, should not happen
            next_state = 2'b00; // default to Walking Left
        end
    endcase
end

assign walk_left = (state == 2'b00) ? 1'b1 : 1'b0;
assign walk_right = (state == 2'b01) ? 1'b1 : 1'b0;
assign aaah = (state == 2'b10) ? 1'b1 : 1'b0;

endmodule