module clkgenerator #(
    parameter PERIOD = 10       // Clock period in base clock cycles (must be even)
)(
    input wire clk_base,        // Base clock input
    input wire reset_n,         // Active-low reset (synchronous)
    output wire clk            // Generated clock output
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
    localparam COUNTER_WIDTH = $clog2(HALF_PERIOD);
    
    reg [COUNTER_WIDTH:0] counter;  // Extra bit for rollover detection
    reg clk_reg;

    always @(posedge clk_base) begin
        if (!reset_n) begin
            counter <= 0;
            clk_reg <= 1'b0;
        end
        else begin
            counter <= counter + 1;
            // Toggle clock when counter rolls over
            if (counter[COUNTER_WIDTH]) begin
                clk_reg <= ~clk_reg;
                counter <= 0;
            end
        end
    end

    assign clk = clk_reg;

endmodule