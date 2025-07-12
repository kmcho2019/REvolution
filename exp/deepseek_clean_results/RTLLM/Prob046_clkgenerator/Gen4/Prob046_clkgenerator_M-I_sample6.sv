module clkgenerator #(
    parameter PERIOD = 10       // Clock period in base clock cycles (must be even)
)(
    input wire clk_base,        // Base clock input
    input wire reset_n,         // Active-low reset (synchronous)
    output reg clk             // Generated clock output
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
    
    reg [COUNTER_WIDTH-1:0] counter;

    always @(posedge clk_base) begin
        if (!reset_n) begin
            counter <= 0;
            clk <= 1'b0;
        end
        else begin
            if (counter == HALF_PERIOD - 1) begin
                clk <= ~clk;
                counter <= 0;
            end
            else begin
                counter <= counter + 1;
            end
        end
    end

endmodule