module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

logic [1:0] counter;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        counter <= 2'b00;
    end else begin
        if (bump_left) begin
            counter <= counter - 1;
        end else if (bump_right) begin
            counter <= counter + 1;
        end
    end
end

assign walk_left = ~counter[0];
assign walk_right = counter[0];

endmodule