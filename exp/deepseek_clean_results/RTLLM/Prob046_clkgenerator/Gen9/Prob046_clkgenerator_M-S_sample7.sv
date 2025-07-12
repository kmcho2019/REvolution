module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk = 0
);

    reg [31:0] counter = 0;

    always @(*) begin
        if (counter >= PERIOD-1)
            counter = 0;
        else
            counter = counter + 1;
    end

    always @(*) begin
        if (counter == PERIOD/2-1)
            clk = ~clk;
    end

endmodule