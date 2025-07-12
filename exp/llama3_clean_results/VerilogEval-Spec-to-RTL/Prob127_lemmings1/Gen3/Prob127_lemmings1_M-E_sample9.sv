module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

logic state_left;
logic state_right;

assign walk_left = state_left;
assign walk_right = state_right;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state_left <= 1;
        state_right <= 0;
    end else begin
        if (bump_left) begin
            state_left <= 0;
            state_right <= 1;
        end else if (bump_right) begin
            state_left <= 1;
            state_right <= 0;
        end
    end
end

endmodule