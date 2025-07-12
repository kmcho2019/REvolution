module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

parameter INIT = 32'h1;
wire [31:0] next_q = {1'b0, q[31:1]} ^ (q[0] ? 32'h80000043 : 32'h0);

always @(posedge clk) begin
    q <= reset ? INIT : next_q;
end

endmodule