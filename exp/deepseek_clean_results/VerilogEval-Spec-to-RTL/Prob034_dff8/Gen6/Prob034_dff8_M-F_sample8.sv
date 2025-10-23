module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] data_reg = 8'b0;  // Initialize to zero

always @(posedge clk) begin
    data_reg <= d;
end

assign q = data_reg;

endmodule