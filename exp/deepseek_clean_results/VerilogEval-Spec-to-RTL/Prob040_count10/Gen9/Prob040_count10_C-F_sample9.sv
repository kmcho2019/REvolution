module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q = (q[3] & q[0]) ? 4'b0000 : q + 1'b1;

always @(posedge clk) begin
    q <= reset ? 4'b0000 : next_q;
end

endmodule