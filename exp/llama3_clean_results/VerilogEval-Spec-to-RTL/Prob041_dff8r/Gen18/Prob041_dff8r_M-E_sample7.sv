module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

logic [7:0] shift_reg;

always_ff @(posedge clk) begin
    if (reset) begin
        shift_reg <= 8'd0;
    end else begin
        shift_reg <= {d[7], shift_reg[7:1]};
    end
end

assign q = shift_reg;

endmodule