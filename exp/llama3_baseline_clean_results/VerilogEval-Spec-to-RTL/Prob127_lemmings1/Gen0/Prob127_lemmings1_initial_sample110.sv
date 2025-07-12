module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

reg state_left;
reg state_right;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_left <= 1'b1;
        state_right <= 1'b0;
    end else begin
        if (state_left) begin
            if (bump_left) begin
                state_left <= 1'b0;
                state_right <= 1'b1;
            end else begin
                state_left <= 1'b1;
                state_right <= 1'b0;
            end
        end else if (state_right) begin
            if (bump_right) begin
                state_left <= 1'b1;
                state_right <= 1'b0;
            end else begin
                state_left <= 1'b0;
                state_right <= 1'b1;
            end
        end
    end
end

assign walk_left = state_left;
assign walk_right = state_right;

endmodule