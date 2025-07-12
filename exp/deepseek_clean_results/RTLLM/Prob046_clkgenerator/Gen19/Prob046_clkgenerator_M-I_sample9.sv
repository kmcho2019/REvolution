module clkgenerator #(
    parameter PERIOD = 10       // Desired clock period in reference clock cycles
)(
    input wire ref_clk,        // Reference clock input
    input wire reset_n,        // Active-low reset
    input wire enable,         // Clock enable
    output reg clk             // Generated clock output
);

    // Calculate counter maximum value (period/2 - 1)
    localparam HALF_PERIOD = PERIOD/2;
    reg [$clog2(HALF_PERIOD):0] counter;  // Extra bit to prevent overflow

    initial begin
        clk = 1'b0;  // Initialize for simulation
    end

    always @(posedge ref_clk or negedge reset_n) begin
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