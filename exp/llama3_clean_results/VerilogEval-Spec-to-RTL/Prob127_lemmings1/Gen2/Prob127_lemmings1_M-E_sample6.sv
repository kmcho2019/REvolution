module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg [1:0] state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // initialize to LEFT
    end else begin
        if (bump_left && (state == 2'b01)) begin
            state <= 2'b10; // switch to RIGHT
        end else if (bump_right && (state == 2'b10)) begin
            state <= 2'b01; // switch to LEFT
        end else if (bump_left && bump_right) begin
            state <= ~state; // switch direction
        end
    end
end

always_comb begin
    if (state == 2'b01) begin
        walk_left = 1'b1;
        walk_right = 1'b0;
    end else if (state == 2'b10) begin
        walk_left = 1'b0;
        walk_right = 1'b1;
    end else begin
        walk_left = 1'b0;
        walk_right = 1'b0;
    end
end

endmodule