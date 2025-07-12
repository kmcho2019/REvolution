module clkgenerator #(
    parameter PERIOD = 10       // Clock period in time units
)(
    input wire enable,          // Clock enable signal
    input wire reset_n,         // Active-low reset
    output reg clk             // Generated clock output
);

    localparam HALF_PERIOD = PERIOD / 2;
    reg [7:0] counter;

    always begin
        #HALF_PERIOD;
        if (reset_n && enable) begin
            clk = ~clk;
        end
    end

    initial begin
        clk = 1'b0;
        forever begin
            #HALF_PERIOD;
            if (reset_n && enable) begin
                clk = ~clk;
            end
        end
    end

endmodule