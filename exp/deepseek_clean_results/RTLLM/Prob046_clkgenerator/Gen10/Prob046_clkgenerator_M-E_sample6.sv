module clkgenerator #(
    parameter PERIOD = 10       // Clock period in base clock cycles
)(
    input wire clk_base,        // Base clock input
    input wire reset_n,         // Active-low reset (synchronous)
    input wire enable,          // Clock generation enable
    output reg clk             // Generated clock output
);

    // Calculate required pointer width
    localparam PTR_WIDTH = $clog2(PERIOD);
    
    // Waveform storage (ROM)
    reg [0:PERIOD-1] waveform;
    integer i;
    
    // Initialize waveform ROM (square wave with 50% duty cycle)
    initial begin
        for (i = 0; i < PERIOD; i = i + 1) begin
            waveform[i] = (i < PERIOD/2) ? 1'b1 : 1'b0;
        end
    end
    
    // Pointer counter
    reg [PTR_WIDTH-1:0] pointer;
    
    // Sequential logic
    always @(posedge clk_base) begin
        if (!reset_n) begin
            pointer <= 0;
            clk <= 1'b0;
        end
        else if (enable) begin
            pointer <= (pointer == PERIOD-1) ? 0 : pointer + 1;
            clk <= waveform[pointer];
        end
        else begin
            pointer <= 0;
            clk <= 1'b0;
        end
    end

endmodule