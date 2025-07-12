module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

logic state;

assign walk_left = ~state;
assign walk_right = state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
    end else begin
        if ((state == 0 && bump_left) || (state == 1 && bump_right)) begin
            state <= ~state;
        end
    end
end

endmodule