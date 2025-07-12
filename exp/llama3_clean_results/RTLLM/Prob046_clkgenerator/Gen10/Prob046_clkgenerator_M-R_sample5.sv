module clkgenerator #(
    parameter PERIOD = 10
)(
    output clk
);

reg internal_clk;

assign clk = internal_clk;

initial begin
    internal_clk = 0;
end

always begin
    #((PERIOD / 2)) internal_clk <= ~internal_clk;
end

endmodule