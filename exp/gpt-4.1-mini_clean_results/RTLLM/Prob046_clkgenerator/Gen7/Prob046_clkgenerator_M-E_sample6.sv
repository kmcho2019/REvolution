module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);
    // Calculate half period as integer cycles
    localparam integer half_period = PERIOD / 2;

    integer count;

    initial begin
        clk = 1'b0;
        count = 0;
    end

    always begin
        #1; // time step of 1 unit
        count = count + 1;
        if (count >= half_period) begin
            clk = ~clk;
            count = 0;
        end
    end
endmodule