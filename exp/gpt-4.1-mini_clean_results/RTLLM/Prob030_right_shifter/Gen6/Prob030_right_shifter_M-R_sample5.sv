module right_shifter (
    input wire clk,
    input wire d,
    output wire [7:0] q
);

reg [7:0] q_reg;

initial begin
    q_reg = 8'b0;
end

always @(posedge clk) begin
    q_reg <= {d, q_reg[7:1]};
end

assign q = q_reg;

endmodule