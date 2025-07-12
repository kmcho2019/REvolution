module clkgenerator #(parameter PERIOD = 10)
                  (output reg clk);

    initial begin
        clk = 0;
        #5; // initial delay for demonstration
        $display("Clock Generator Started");
    end

    always begin
        #((PERIOD / 2)) clk = ~clk; // toggle clk every half of PERIOD
    end

endmodule

module tb_clkgenerator;
    reg clk;

    clkgenerator #(.PERIOD(10)) uut (.clk(clk));

    initial begin
        $monitor("Time = %0d, clk = %0b", $time, clk);
        #20 $finish;
    end
endmodule