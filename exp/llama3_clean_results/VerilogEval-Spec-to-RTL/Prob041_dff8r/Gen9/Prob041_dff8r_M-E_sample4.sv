module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

logic [7:0] reg;

always_ff @(posedge clk) begin
    if (reset) begin
        reg <= 8'b0;
    end else begin
        reg <= d;
    end
end

assign q = reg;

endmodule