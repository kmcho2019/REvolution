module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] shift_reg;

always @(negedge clk) begin
    if (reset) begin
        shift_reg <= 8'h34;
    end else begin
        shift_reg <= {d[7], d[6:0]};
    end
end

assign q = shift_reg;

endmodule