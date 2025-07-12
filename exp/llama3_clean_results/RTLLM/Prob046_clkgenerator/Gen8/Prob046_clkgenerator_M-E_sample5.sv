module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

real elapsed_time;
real half_period;

initial begin
    half_period = PERIOD / 2.0;
    elapsed_time = 0;
    clk = 0;
end

always #1 begin
    elapsed_time = elapsed_time + 1;
    if (elapsed_time >= half_period) begin
        elapsed_time = 0;
        clk = ~clk;
    end
end

endmodule