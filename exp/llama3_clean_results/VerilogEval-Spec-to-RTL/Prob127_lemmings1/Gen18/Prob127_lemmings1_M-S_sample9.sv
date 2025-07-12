module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

reg state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Initialize state to 0 (LEFT)
    end else begin
        state <= (bump_left || bump_right)? ~state : state;
    end
end

assign walk_left = ~state;
assign walk_right = state;

endmodule