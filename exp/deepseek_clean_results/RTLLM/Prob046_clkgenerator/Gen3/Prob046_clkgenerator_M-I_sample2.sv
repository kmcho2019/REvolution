module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);

    localparam HALF_PERIOD = PERIOD / 2;
    
    initial clk = 0;
    
    always begin
        #HALF_PERIOD clk = ~clk;
    end

endmodule