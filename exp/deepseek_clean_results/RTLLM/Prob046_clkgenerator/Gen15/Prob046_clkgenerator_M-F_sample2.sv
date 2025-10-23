module clkgenerator #(
    parameter PERIOD = 10       // Clock period in time units
)(
    output reg clk             // Generated clock output
);

    // Calculate required counter width based on PERIOD
    localparam COUNTER_WIDTH = $clog2(PERIOD);
    reg [COUNTER_WIDTH-1:0] counter = 0;
    localparam HALF_PERIOD = PERIOD / 2;

    always @(*) begin
        if (counter >= PERIOD-1) begin
            counter = 0;
        end else begin
            counter = counter + 1;
        end
    end

    always @(*) begin
        if (counter < HALF_PERIOD) begin
            clk = 1'b0;
        end else begin
            clk = 1'b1;
        end
    end

    initial begin
        clk = 1'b0;  // Initial state
    end

endmodule