module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] data_reg;
wire [7:0] reset_pattern = 8'b00110100; // 0x34

always @(negedge clk) begin
    if (reset) begin
        data_reg <= reset_pattern;
    end else begin
        data_reg <= d;
    end
end

assign q = data_reg;

endmodule