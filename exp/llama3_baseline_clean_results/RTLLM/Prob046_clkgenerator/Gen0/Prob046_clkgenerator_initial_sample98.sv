module clkgenerator #(parameter PERIOD = 10)
                   (output reg clk);

    initial begin
        clk = 0;  // Initialize the clock to 0
    end

    always #(PERIOD/2) begin  // Toggle the clock every half of the period
        clk = ~clk;  // Invert the current state of the clock
    end

endmodule