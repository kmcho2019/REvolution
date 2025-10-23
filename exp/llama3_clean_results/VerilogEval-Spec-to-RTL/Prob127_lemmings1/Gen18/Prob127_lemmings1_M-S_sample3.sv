module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Walk left by default
        walk_left <= 1;
        walk_right <= 0;
    end else begin
        if (bump_left && bump_right) begin
            state <= ~state; // Switch direction
        end else if (state == 0) begin
            state <= bump_left? 1 : 0;
        end else begin
            state <= bump_right? 0 : 1;
        end
        walk_left <= (state == 0);
        walk_right <= (state == 1);
    end
end

endmodule