module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

logic current_state, next_state;

always_comb begin
    if (current_state) begin
        next_state = bump_left ? 0 : current_state;
    end else begin
        next_state = bump_right ? 1 : current_state;
    end
end

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 0;
    end else begin
        current_state <= next_state;
    end
end

always_comb begin
    walk_left = ~current_state;
    walk_right = current_state;
end

endmodule