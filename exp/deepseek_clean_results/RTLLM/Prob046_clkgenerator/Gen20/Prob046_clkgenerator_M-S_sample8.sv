module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk = 1'b0  // Clock output initialized to 0
);

    always begin
        #(PERIOD/2) clk = ~clk;  // Toggle clock every half period
    end

endmodule