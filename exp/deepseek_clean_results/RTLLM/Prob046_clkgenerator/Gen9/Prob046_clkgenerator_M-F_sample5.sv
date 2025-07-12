module clkgenerator #(
    parameter PERIOD = 10       // Clock period in base clock cycles (must be even)
)(
    input wire clk_base,        // Base clock input
    input wire reset_n,         // Active-low reset (synchronous)
    input wire enable,          // Clock generation enable
    output wire clk             // Generated clock output
);

    // Validate parameter (PERIOD must be even for 50% duty cycle)
    generate
        if (PERIOD % 2 != 0) begin
            initial begin
                $error("PERIOD must be even for 50%% duty cycle");
                $finish;
            end
        end
    endgenerate

    // Calculate required counter width and half period
    localparam HALF_PERIOD = PERIOD / 2;
    localparam COUNTER_WIDTH = $clog2(HALF_PERIOD + 1);
    
    reg [COUNTER_WIDTH-1:0] counter;
    reg clk_reg;
    
    // Sequential logic (flip-flops)
    always @(posedge clk_base) begin
        if (!reset_n) begin
            counter <= HALF_PERIOD - 1;
            clk_reg <= 1'b0;
        end
        else if (enable) begin
            // Counter and clock toggle logic
            if (counter == 0) begin
                counter <= HALF_PERIOD - 1;
                clk_reg <= ~clk_reg;
            end
            else begin
                counter <= counter - 1;
            end
        end
        else begin
            // Hold counter when disabled
            counter <= HALF_PERIOD - 1;
        end
    end

    assign clk = enable ? clk_reg : 1'b0;

endmodule