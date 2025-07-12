module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);

localparam HALF_PERIOD = (PERIOD >> 1) == 0 ? 1 : (PERIOD >> 1);

initial clk = 1'b0;

always begin
    #HALF_PERIOD clk = ~clk;
end

endmodule