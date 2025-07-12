module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);

reg [31:0] count; // Counter for timing

initial begin
    clk = 0;
    count = 0;
end

always begin
    #(1); // Time step of 1 time unit
    count = count + 1;
    if (count >= (PERIOD/2)) begin
        clk = ~clk;
        count = 0;
    end
end

endmodule