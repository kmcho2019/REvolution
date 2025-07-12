module TopModule(
    input         clk,
    input         resetn,
    input  [1:0]  byteena,
    input  [15:0] d,
    output [15:0] q
);

reg [15:0] q_reg;

always @(posedge clk) begin
    q_reg[15:8] <= (~resetn) ? 8'd0 : (byteena[1]) ? d[15:8] : q_reg[15:8];
    q_reg[7:0]  <= (~resetn) ? 8'd0 : (byteena[0]) ? d[7:0]  : q_reg[7:0];
end

assign q = q_reg;

endmodule