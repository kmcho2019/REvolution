module clkgenerator #(parameter PERIOD = 10) (
    output reg clk = 0
);
    reg [31:0] counter = 0;

    always @(*) begin
        if (counter >= PERIOD) begin
            counter = 0;
        end
    end

    always begin
        #1;  // Time advancement
        counter = counter + 1;
        
        if (counter == (PERIOD/2)) begin
            clk = ~clk;
        end
        else if (counter == PERIOD) begin
            clk = ~clk;
            counter = 0;
        end
    end
endmodule