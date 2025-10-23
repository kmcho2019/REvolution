module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

reg state; // Using a 1-bit state variable

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Initialize state to LEFT (0)
    end else begin
        state <= (state) ? (!bump_right) : (!bump_left);
    end
end

assign walk_left = !state;
assign walk_right = state;

endmodule