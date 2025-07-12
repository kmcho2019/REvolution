module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);
    reg [31:0] counter;
    
    initial begin
        clk = 1'b0;
        counter = 0;
    end

    always @(*) begin
        if (counter >= (PERIOD/2 - 1)) begin
            clk = ~clk;
            counter = 0;
        end
    end

    always #1 begin
        if (counter < (PERIOD/2 - 1)) begin
            counter <= counter + 1;
        end
    end

endmodule