module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [1:0] state;
reg [1:0] next_state;

// State encoding: 0 - walking left, 1 - walking right
always @(*) begin
    case(state)
        2'b0: // walking left
            if (bump_left || bump_right) begin
                next_state = 2'b1; // switch to walking right
            end else begin
                next_state = 2'b0; // stay walking left
            end
        2'b1: // walking right
            if (bump_left || bump_right) begin
                next_state = 2'b0; // switch to walking left
            end else begin
                next_state = 2'b1; // stay walking right
            end
        default: next_state = 2'b0;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b0; // reset to walking left
    end else begin
        state <= next_state;
    end
end

// Output logic
assign walk_left = (state == 2'b0) ? 1'b1 : 1'b0;
assign walk_right = (state == 2'b1) ? 1'b1 : 1'b0;

endmodule