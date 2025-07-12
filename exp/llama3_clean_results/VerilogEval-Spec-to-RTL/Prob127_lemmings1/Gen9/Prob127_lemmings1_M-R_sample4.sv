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
        current_state <= 1'b0; // WALK_LEFT
    end else begin
        if ((current_state == 1'b0 && bump_left) || (current_state == 1'b1 && bump_right)) begin
            current_state <= 1'b1; // WALK_RIGHT
        end else if ((current_state == 1'b0 && bump_right) || (current_state == 1'b1 && bump_left)) begin
            current_state <= 1'b0; // WALK_LEFT
        end else begin
            current_state <= current_state;
        end
    end
end

assign walk_left = ~current_state;
assign walk_right = current_state;

endmodule