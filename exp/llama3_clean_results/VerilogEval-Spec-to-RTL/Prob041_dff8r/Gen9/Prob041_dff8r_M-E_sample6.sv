module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

logic [7:0] shift_reg;

always_ff @(posedge clk) begin
    if (reset) begin
        shift_reg <= 8'b0;
    end else begin
        shift_reg <= {shift_reg[6:0], d[0]};
    end
end

logic [7:0] reset_val;
assign reset_val = 8'b0;

always_comb begin
    for (int i = 0; i < 8; i++) begin
        if (reset) begin
            q[i] = reset_val[i];
        end else begin
            q[i] = shift_reg[i];
        end
    end
end

endmodule