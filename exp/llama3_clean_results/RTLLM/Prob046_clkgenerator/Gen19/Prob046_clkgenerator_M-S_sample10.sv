module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

always begin
    clk = 0;
    #5;
    clk = 1;
    #5;
end

endmodule