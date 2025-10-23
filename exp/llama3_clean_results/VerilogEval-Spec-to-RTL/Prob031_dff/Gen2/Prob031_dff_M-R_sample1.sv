module TopModule(
    input clk,
    input d,
    output reg q
);

reg prev_clk;

always @(clk or d) begin
    if (clk && !prev_clk) begin
        q <= d;
    end
    prev_clk <= clk;
end

initial begin
    prev_clk = 1'b0;
    q = 1'b0;
end

endmodule