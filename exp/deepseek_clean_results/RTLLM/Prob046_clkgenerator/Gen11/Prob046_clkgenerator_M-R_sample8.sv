module clkgenerator #(
    parameter PERIOD = 10
)(
    output wire clk
);

    assign clk = (($realtime % PERIOD) < (PERIOD/2)) ? 1'b0 : 1'b1;

endmodule