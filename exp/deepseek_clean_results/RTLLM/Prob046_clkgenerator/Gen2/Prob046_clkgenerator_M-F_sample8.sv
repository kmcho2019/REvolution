module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);
    reg [31:0] counter;
    
    initial begin
        clk = 1'b0;
        counter = 0;
    end

    always begin
        #(PERIOD/2) clk <= ~clk;
    end

endmodule