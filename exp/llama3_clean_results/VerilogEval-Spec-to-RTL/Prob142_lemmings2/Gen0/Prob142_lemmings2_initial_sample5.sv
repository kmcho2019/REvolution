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

reg [1:0] state; // 0: walking left, 1: walking right, 2: falling
reg [1:0] prevState; // previous state before falling

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // walking left
        prevState <= 0; // previous state is walking left
    end else begin
        if (ground == 0) begin
            state <= 2; // falling
            prevState <= state; // save previous state
        end else if (state == 2) begin
            state <= prevState; // go back to previous state
        end else begin
            if (bump_left == 1) begin
                state <= 1; // walk right
            end else if (bump_right == 1) begin
                state <= 0; // walk left
            end
        end
    end
end

always @(state) begin
    case (state)
        0: begin
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
        end
        1: begin
            walk_left <= 0;
            walk_right <= 1;
            aaah <= 0;
        end
        2: begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 1;
        end
    endcase
end

endmodule