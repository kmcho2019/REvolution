module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    integer count;

    initial begin
        clk = 0;
        count = 0;
        forever begin
            #1; // 1 time unit tick
            count = count + 1;
            if (count >= (PERIOD + 1)/2) begin
                clk = ~clk;
                count = 0;
            end
        end
    end

endmodule