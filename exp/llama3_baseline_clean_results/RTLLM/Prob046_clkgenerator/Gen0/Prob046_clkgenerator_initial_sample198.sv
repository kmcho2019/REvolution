module clkgenerator #
(
    parameter PERIOD = 10
)
(
    output reg clk
);

initial begin
    clk = 0;
    forever begin
        #((PERIOD / 2));
        clk = ~clk;
        $display("Time = %0t, clk = %0b", $time, clk);
    end
end

endmodule

module testbench;
    reg [31:0] cycle;
    wire clk;

    clkgenerator #(.PERIOD(10)) uut (.clk(clk));

    initial begin
        cycle = 0;
        #100;
        $finish;
    end

endmodule