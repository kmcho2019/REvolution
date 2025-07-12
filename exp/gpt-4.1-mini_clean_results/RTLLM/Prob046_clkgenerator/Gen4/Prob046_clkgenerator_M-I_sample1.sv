module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);

initial clk = 1'b0;

always begin
    #(PERIOD/2);
    clk = ~clk;
end

endmodule