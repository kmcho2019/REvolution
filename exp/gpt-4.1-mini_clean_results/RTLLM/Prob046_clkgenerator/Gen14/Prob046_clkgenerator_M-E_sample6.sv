module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

integer count;
localparam HALF_PERIOD = PERIOD / 2;

initial begin
    clk = 1'b0;
    count = 0;
end

always begin
    #1; // time unit step

    count = count + 1;
    if (count >= HALF_PERIOD) begin
        clk = ~clk;
        count = 0;
    end
end

endmodule