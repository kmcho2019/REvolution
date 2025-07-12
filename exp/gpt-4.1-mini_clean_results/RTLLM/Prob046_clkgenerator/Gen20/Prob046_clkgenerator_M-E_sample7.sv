module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);
    integer i;
    initial begin
        clk = 0;
        // Generate clock toggles for a large number of cycles to ensure steady waveform
        for (i = 0; i < 1000; i = i + 1) begin
            #(PERIOD/2) clk = ~clk;
        end
    end
endmodule