module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

initial begin
    clk = 0; // Initialize the clock signal to 0
    forever begin
        #((PERIOD / 2)); // Wait for half of the period
        clk = ~clk; // Toggle the clock signal
    end
end

endmodule

// Testbench for the clkgenerator module
module testbench;
    reg clk;

    clkgenerator #(.PERIOD(10)) uut (
       .clk(clk)
    );

    initial begin
        $display("Time\tclk");
        $monitor("%0t\t%0b", $time, clk);
        #100 $finish; // Run the simulation for 100 time units
    end
endmodule