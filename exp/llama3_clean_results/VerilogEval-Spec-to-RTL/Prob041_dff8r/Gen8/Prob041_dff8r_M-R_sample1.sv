module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

logic [7:0] q_reg;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 8'b0;
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule