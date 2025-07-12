module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

reg walk; // 1-bit state variable

always @(posedge clk or posedge areset) begin
    if (areset) begin
        walk <= 1'b1; // Initialize walk_left to 1
    end else begin
        walk <= (bump_left) ? 1'b0 : (bump_right) ? 1'b1 : walk;
    end
end

assign walk_left = walk;
assign walk_right = ~walk;

endmodule