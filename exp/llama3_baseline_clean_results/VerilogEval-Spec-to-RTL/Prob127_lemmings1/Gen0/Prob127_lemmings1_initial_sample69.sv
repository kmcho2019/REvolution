module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

reg [1:0] state; // 0: walk_left, 1: walk_right
reg [1:0] next_state;

always @(*) begin
    case(state)
        0: begin // walk_left
            if (bump_left || bump_right) begin
                next_state = 1; // walk_right
            end else begin
                next_state = 0; // walk_left
            end
        end
        1: begin // walk_right
            if (bump_left || bump_right) begin
                next_state = 0; // walk_left
            end else begin
                next_state = 1; // walk_right
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // walk_left
    end else begin
        state <= next_state;
    end
end

assign walk_left = (state == 0);
assign walk_right = (state == 1);

endmodule