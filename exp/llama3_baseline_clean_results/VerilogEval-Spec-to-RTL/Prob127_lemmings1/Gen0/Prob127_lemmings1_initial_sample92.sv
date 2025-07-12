module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

reg [0:0] state;
reg [0:0] next_state;

always @(*) begin
    case(state)
        1'b0: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            if (bump_left == 1'b1) begin
                next_state = 1'b1;
            end else begin
                next_state = 1'b0;
            end
        end
        1'b1: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            if (bump_right == 1'b1) begin
                next_state = 1'b0;
            end else begin
                next_state = 1'b1;
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        state <= 1'b0;
    end else begin
        if (bump_left == 1'b1 && bump_right == 1'b1) begin
            state <= ~state;
        end else if (bump_left == 1'b1) begin
            state <= 1'b1;
        end else if (bump_right == 1'b1) begin
            state <= 1'b0;
        end else begin
            state <= state;
        end
    end
end

endmodule