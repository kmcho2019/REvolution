module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk = 1'b0  // Clock output initialized to 0
);

    // Continuous clock generation
    always begin
        #(PERIOD/2) clk = ~clk;
    end

    // Initial block to ensure first edge happens at correct time
    initial begin
        #(PERIOD/2) clk = 1'b1;
    end

endmodule