module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

always begin
    clk = 1'b0; #((PERIOD / 2));
    clk = 1'b1; #((PERIOD / 2));
end

endmodule