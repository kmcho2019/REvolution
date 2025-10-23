module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] state;
reg [0:0] next_state;

always @(*) begin
    case(state)
        1'b0: begin // walking left
            if (bump_left == 1'b1) begin
                next_state = 1'b1; // switch to walking right
            end else begin
                next_state = 1'b0; // stay walking left
            end
        end
        1'b1: begin // walking right
            if (bump_right == 1'b1) begin
                next_state = 1'b0; // switch to walking left
            end else begin
                next_state = 1'b1; // stay walking right
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        state <= 1'b0; // reset to walking left
    end else begin
        if (bump_left == 1'b1 && bump_right == 1'b1) begin
            state <= ~state; // switch directions
        end else begin
            state <= next_state;
        end
    end
end

assign walk_left = (state == 1'b0) ? 1'b1 : 1'b0;
assign walk_right = (state == 1'b1) ? 1'b1 : 1'b0;

endmodule