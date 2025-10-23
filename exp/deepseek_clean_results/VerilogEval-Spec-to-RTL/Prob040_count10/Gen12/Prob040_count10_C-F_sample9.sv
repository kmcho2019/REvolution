module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] q_reg;
wire [3:0] q_next;

assign q_next = (q_reg == 4'b1001) ? 4'b0000 : q_reg + 1'b1;
assign q = q_reg;

always @(posedge clk) begin
    q_reg <= reset ? 4'b0000 : q_next;
end

endmodule