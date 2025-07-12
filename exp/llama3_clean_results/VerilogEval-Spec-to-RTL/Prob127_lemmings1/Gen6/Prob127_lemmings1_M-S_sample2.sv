module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

logic current_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1'b0; // walk left
    end else if (bump_left || bump_right) begin
        current_state <= ~current_state;
    end
end

always_comb begin
    walk_left = ~current_state;
    walk_right = current_state;
end

endmodule