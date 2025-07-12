module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

reg [1:0] state;  // State variable (not used as we only need two states)
reg walk_left_reg;
reg walk_right_reg;

// Encoding:
// state[0] = walk_left
// state[1] = walk_right

always @(*) begin
    case ({bump_left, bump_right})
        2'b00: begin
            walk_left_reg = state[0];
            walk_right_reg = state[1];
        end
        2'b01: begin
            walk_left_reg = 1'b1;
            walk_right_reg = 1'b0;
        end
        2'b10: begin
            walk_left_reg = 1'b0;
            walk_right_reg = 1'b1;
        end
        2'b11: begin
            walk_left_reg = ~state[0];
            walk_right_reg = ~state[1];
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state[0] <= 1'b1;
        state[1] <= 1'b0;
    end else begin
        if (~bump_left && ~bump_right) begin
            state[0] <= walk_left_reg;
            state[1] <= walk_right_reg;
        end else if (bump_left && ~bump_right) begin
            state[0] <= 1'b0;
            state[1] <= 1'b1;
        end else if (~bump_left && bump_right) begin
            state[0] <= 1'b1;
            state[1] <= 1'b0;
        end else begin
            state[0] <= ~state[0];
            state[1] <= ~state[1];
        end
    end
end

assign walk_left = state[0];
assign walk_right = state[1];

endmodule