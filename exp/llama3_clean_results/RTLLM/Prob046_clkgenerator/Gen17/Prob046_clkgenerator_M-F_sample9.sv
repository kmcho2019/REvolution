module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

integer counter = 0;

always begin
    #1; // increment counter at every time unit
    counter = counter + 1;
    if (counter == (PERIOD / 2)) begin
        counter = 0;
        clk = ~clk;
    end
end

initial begin
    clk = 0;
end

endmodule