module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);

integer count;

initial begin
    clk = 0;
    count = 0;
end

always begin
    #1; // wait 1 time unit
    count = count + 1;
    if (count >= PERIOD/2) begin
        clk = ~clk;
        count = 0;
    end
end

endmodule