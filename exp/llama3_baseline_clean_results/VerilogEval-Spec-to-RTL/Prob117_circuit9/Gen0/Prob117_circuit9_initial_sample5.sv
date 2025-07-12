module TopModule (
    input  clk,
    input  a,
    output [2:0] q
);

reg [2:0] q_reg;

always @(posedge clk) begin
    if (~a) begin
        q_reg <= q_reg + 1;
    end
end

assign q = q_reg;

initial begin
    q_reg = 4'b100;  // initialize q to 4
end

endmodule