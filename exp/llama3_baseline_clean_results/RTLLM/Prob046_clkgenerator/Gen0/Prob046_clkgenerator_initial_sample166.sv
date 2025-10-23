module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

initial begin
    clk = 0;
    forever begin
        #((PERIOD / 2)) clk = ~clk;
    end
end

endmodule

// Testbench to verify the generated clock signal
module tb_clkgenerator;
    reg [31:0] period_count;
    wire clk;

    clkgenerator #(.PERIOD(10)) u_clkgenerator (
       .clk(clk)
    );

    initial begin
        $monitor("Time = %0t, Clk = %0b", $time, clk);
        #100; // run for 100 time units
        $finish;
    end

endmodule