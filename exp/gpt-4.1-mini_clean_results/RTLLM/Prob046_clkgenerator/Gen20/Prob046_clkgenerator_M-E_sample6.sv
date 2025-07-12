module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    // Internal counter for timing the clock toggle
    integer counter;

    initial begin
        clk = 0;
        counter = 0;
    end

    // Increment counter every 1 time unit, toggle clk at half PERIOD
    always begin
        #1;  // wait 1 time unit
        counter = counter + 1;
        if (counter >= (PERIOD+1)/2) begin
            clk = ~clk;
            counter = 0;
        end
    end

endmodule