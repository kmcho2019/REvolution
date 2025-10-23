module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] state; // 0: walking left, 1: walking right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
    end else begin
        if (bump_left == 1'b1) begin
            state <= 1;
        end else if (bump_right == 1'b1) begin
            state <= 0;
        end
    end
end

always @(*) begin
    case (state)
        0: begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
        end
        1: begin
            walk_left <= 1'b0;
            walk_right <= 1'b1;
        end
        default: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
        end
    endcase
end

endmodule