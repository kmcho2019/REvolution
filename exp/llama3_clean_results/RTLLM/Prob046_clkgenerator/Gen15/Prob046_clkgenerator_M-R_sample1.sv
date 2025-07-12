module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] time_counter;

initial begin
    time_counter = 0;
    forever begin
        #1 time_counter = time_counter + 1;
        if (time_counter % (PERIOD / 2) == 0) begin
            clk = ~clk;
        end
    end
end

endmodule