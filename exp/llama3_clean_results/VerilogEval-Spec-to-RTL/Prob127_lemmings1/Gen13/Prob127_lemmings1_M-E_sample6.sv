module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg [0:0] counter;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        counter <= 0;
    end else begin
        if (bump_left && !bump_right) begin
            counter <= ~counter;
        end else if (!bump_left && bump_right) begin
            counter <= ~counter;
        end else if (bump_left && bump_right) begin
            counter <= ~counter;
        end
    end
end

always_comb begin
    walk_left = ~counter;
    walk_right = counter;
end

endmodule