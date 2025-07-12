module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);

    reg [31:0] counter;

    initial begin
        clk = 1'b0;
        counter = 0;
    end

    always @(*) begin
        if (counter >= PERIOD) begin
            counter = 0;
        end
    end

    always begin
        #1 counter = counter + 1;
        if (counter == (PERIOD/2)) begin
            clk = ~clk;
        end
    end

endmodule