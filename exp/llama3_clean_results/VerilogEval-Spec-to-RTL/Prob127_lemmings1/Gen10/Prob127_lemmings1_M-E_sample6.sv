module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg direction;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 0;
    end else begin
        if ((direction == 0 && bump_left) || (direction == 1 && bump_right) || (bump_left && bump_right)) begin
            direction <= ~direction;
        end
    end
end

// Combinational logic
always_comb begin
    case (direction)
        0: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        1: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
    endcase
end

endmodule