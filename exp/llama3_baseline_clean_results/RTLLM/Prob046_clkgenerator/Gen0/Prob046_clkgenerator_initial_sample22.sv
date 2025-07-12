module clkgenerator(
    output reg clk
);
    parameter PERIOD = 10;

    initial begin
        clk = 0; // Initialize the clock signal to 0
        forever begin
            #((PERIOD / 2)); // Wait for half of the period
            clk = ~clk; // Toggle the clock signal
            if ($time > 100) $finish; // Stop simulation after 100 time units
        end
    end
endmodule

module testbench;
    reg clk;
    clkgenerator uut(.clk(clk));

    initial begin
        $monitor("Time = %0d, Clk = %0b", $time, clk);
        #200 $finish; // Run simulation for 200 time units
    end
endmodule