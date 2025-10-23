module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg direction;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 1'b0; // Initial direction: left
    end else begin
        if (bump_left || bump_right) begin
            direction <= ~direction; // Toggle direction on bump
        end
    end
end

always_comb begin
    case (direction)
        1'b0: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        1'b1: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
    endcase
end

endmodule