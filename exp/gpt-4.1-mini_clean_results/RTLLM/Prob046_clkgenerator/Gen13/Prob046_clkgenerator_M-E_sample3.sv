module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

integer counter;

initial begin
    clk = 1'b0;
    counter = 0;
end

always begin
    #1;  // simulate a time unit step
    counter = counter + 1;
    if (counter >= (PERIOD/2)) begin
        clk = ~clk;
        counter = 0;
    end
end

endmodule