module clkgenerator #(
    parameter PERIOD = 10       // Clock period in base clock cycles (must be even)
)(
    input wire clk_base,        // Base clock input
    input wire reset_n,         // Active-low reset (synchronous)
    output wire clk             // Generated clock output (now continuous assignment)
);

    // Validate parameter (PERIOD must be even for 50% duty cycle)
    initial begin
        if (PERIOD % 2 != 0) begin
            $error("PERIOD must be even for 50%% duty cycle");
            $finish;
        end
    end

    // Calculate required counter width and half period
    localparam HALF_PERIOD = PERIOD / 2;
    localparam COUNTER_WIDTH = $clog2(PERIOD);
    
    reg [COUNTER_WIDTH-1:0] counter;

    // Free-running counter with synchronous reset
    always @(posedge clk_base) begin
        if (!reset_n) begin
            counter <= 0;
        end
        else begin
            counter <= (counter == PERIOD - 1) ? 0 : counter + 1;
        end
    end

    // Clock generation via continuous assignment
    assign clk = (counter < HALF_PERIOD) ? 1'b0 : 1'b1;

endmodule