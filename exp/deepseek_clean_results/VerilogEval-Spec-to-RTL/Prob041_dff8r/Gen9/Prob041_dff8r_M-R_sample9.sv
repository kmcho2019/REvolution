module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

assign q = q_reg;

always @(posedge clk) begin
    q_reg <= reset ? 8'b0 : d;
end

endmodule