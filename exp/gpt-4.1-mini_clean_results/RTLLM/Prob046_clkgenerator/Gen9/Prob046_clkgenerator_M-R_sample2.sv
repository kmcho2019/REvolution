module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);

localparam integer HALF_PERIOD = (PERIOD < 2) ? 1 : (PERIOD / 2);

integer counter;

initial begin
    clk = 1'b0;
    counter = 0;
end

// Simulation-only clock generation using counter increment every 1 time unit
always begin
    #1;
    counter = counter + 1;
    if (counter >= HALF_PERIOD) begin
        clk = ~clk;
        counter = 0;
    end
end

endmodule