module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    integer count;

    initial begin
        clk = 1'b0;
        count = 0;
    end

    always begin
        #1;                 // wait one time unit
        count = count + 1;
        if (count >= PERIOD/2) begin
            clk = ~clk;
            count = 0;
        end
    end

endmodule