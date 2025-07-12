module TopModule(
    input           clk,
    input   [7:0]    d,
    output  [7:0]    q
);

reg [7:0] q_reg;

integer i;
always @(posedge clk) begin
    for (i = 0; i < 8; i = i + 1) begin
        q_reg[i] <= d[i];
    end
end

assign q = q_reg;

endmodule