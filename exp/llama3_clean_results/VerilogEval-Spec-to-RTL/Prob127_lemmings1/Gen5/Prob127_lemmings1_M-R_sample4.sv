module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

logic state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0; // Initial state: walk_left
    end else begin
        state <= bump_left? ~state : (bump_right? ~state : state);
    end
end

assign walk_left = ~state;
assign walk_right = state;

endmodule