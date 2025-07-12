module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);

integer time_count;

initial begin
    clk = 0;
    time_count = 0;
end

// Simulate a free-running time counter incrementing every 1 time unit
initial begin
    forever #1 time_count = time_count + 1;
end

// Toggle clock every half PERIOD time units
always @(time_count) begin
    if ((time_count % (PERIOD/2)) == 0) begin
        clk = ~clk;
    end
end

endmodule