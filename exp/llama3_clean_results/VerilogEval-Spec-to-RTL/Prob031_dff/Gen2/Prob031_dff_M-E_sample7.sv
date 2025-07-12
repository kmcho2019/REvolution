module TopModule(
    input clk,
    input d,
    output reg q
);

reg intermediate;

always @(clk or d) begin
    if (clk) begin
        intermediate <= d;
    end
end

always @(clk or intermediate) begin
    if (!clk) begin
        q <= intermediate;
    end
end

endmodule