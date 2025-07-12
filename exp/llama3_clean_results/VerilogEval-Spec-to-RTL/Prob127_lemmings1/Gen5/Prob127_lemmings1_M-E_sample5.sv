module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

logic direction;

assign walk_left = ~direction;
assign walk_right = direction;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= 0;
    end else if (bump_left || bump_right) begin
        direction <= ~direction;
    end
end

endmodule