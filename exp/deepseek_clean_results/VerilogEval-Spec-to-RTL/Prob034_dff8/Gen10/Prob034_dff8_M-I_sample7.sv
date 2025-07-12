module TopModule (
    input        clk,
    input  [7:0] d,
    output [7:0] q
);

parameter WIDTH = 8;
reg [WIDTH-1:0] data_reg;

always @(posedge clk) begin
    data_reg <= d;
end

assign q = data_reg;

endmodule