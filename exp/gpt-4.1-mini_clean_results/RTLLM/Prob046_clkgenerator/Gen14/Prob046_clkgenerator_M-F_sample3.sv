module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

initial clk = 1'b0;

always begin
    #(PERIOD/2.0);
    clk = ~clk;
end

endmodule