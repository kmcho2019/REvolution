module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q_reg;

initial q_reg = 4;

always @(posedge clk) begin
    if (~a) begin
        q_reg = q_reg + 1;
        if (q_reg == 8)
            q_reg = 0;
    end
end

assign q = q_reg;

endmodule