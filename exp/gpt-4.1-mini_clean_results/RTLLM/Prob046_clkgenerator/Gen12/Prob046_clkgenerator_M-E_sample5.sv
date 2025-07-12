module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);

    // Internal counter to track elapsed time units
    reg [$clog2(PERIOD):0] count;

    initial begin
        clk = 0;
        count = 0;
    end

    // Base time tick: every 1 time unit, increment the counter
    always #1 begin
        count = count + 1;
        if (count >= (PERIOD/2)) begin
            clk = ~clk;
            count = 0;
        end
    end

endmodule