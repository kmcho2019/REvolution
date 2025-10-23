module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [$clog2(PERIOD)-1:0] counter = 0;

always @(posedge $global_clock) begin
    counter = counter + 1;
    if (counter == (PERIOD / 2)) begin
        clk = ~clk;
        counter = 0;
    end
end

endmodule