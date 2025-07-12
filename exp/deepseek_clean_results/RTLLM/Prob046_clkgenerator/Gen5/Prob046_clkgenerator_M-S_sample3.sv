module clkgenerator #(
    parameter PERIOD = 10
) (
    output reg clk = 0
);

    always begin
        #(PERIOD/2) clk = ~clk;
    end

    // Simple parameter validation
    initial begin
        if (PERIOD < 2) begin
            $error("PERIOD must be at least 2");
            $finish;
        end
    end
endmodule