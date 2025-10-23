module clkgenerator #(
    parameter PERIOD = 10       // Clock period in time units (must be even)
)(
    input wire reset_n,        // Active-low reset
    input wire enable,         // Clock enable
    output reg clk             // Generated clock output
);

    // Calculate counter maximum value (period/2 - 1)
    localparam HALF_PERIOD = PERIOD/2;
    reg [$clog2(HALF_PERIOD)-1:0] counter;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 0;
            clk <= 1'b0;
        end else if (enable) begin
            if (counter == HALF_PERIOD-1) begin
                counter <= 0;
                clk <= ~clk;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule