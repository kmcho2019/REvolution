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
        shift_reg <= d;
    end
end

always_comb begin
    if (reset) begin
        q = 8'b0;
    end else begin
        q = shift_reg;
    end
end

endmodule