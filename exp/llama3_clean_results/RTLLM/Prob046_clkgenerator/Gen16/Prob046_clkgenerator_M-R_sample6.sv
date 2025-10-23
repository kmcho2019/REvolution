module clkgenerator #(
    parameter PERIOD = 10
)(
    input  sys_clk,
    output reg clk
);

reg [$clog2(PERIOD):0] counter = 0;
localparam half_period = PERIOD / 2;

always @(posedge sys_clk) begin
    counter <= counter + 1;
    if (counter == half_period) begin
        counter <= 0;
        clk <= ~clk;
    end
end

initial begin
    clk = 0;
end

endmodule