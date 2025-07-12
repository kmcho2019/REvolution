module clkgenerator #(
    parameter PERIOD = 10
) (
    input wire reset,
    output reg clk
);

initial clk = 0;

always begin
    if (reset) begin
        clk <= 0;
        @(negedge reset); // wait for reset deassertion
    end
    else begin
        #(PERIOD/2);
        clk <= ~clk;
    end
end

endmodule