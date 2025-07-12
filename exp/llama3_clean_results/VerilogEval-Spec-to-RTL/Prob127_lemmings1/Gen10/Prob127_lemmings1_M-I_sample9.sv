module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg state, next_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0; // LEFT state
    end else begin
        state <= next_state;
    end
end

always_comb begin
    if (bump_left && bump_right) begin
        next_state = ~state; // Switch direction
    end else if (state == 1'b0) begin // LEFT state
        next_state = bump_left ? 1'b1 : 1'b0; // RIGHT state if bumped, else stay
    end else begin // RIGHT state
        next_state = bump_right ? 1'b0 : 1'b1; // LEFT state if bumped, else stay
    end
end

always_comb begin
    case (state)
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