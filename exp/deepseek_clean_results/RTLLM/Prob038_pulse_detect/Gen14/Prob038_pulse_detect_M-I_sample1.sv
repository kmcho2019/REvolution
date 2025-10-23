module pulse_detect #(
    parameter PULSE_WIDTH = 3  // Default detects 0->1->0 (3 cycles)
) (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// History register stores previous samples
reg [PULSE_WIDTH-2:0] history;
// Registered detection for better timing
reg pulse_detected_reg;

// Pulse is detected when we see the complete pattern
wire pulse_detected = (PULSE_WIDTH == 3) ? 
                     (history == 2'b10) && (data_in == 1'b0) :
                     // Add other patterns here if PULSE_WIDTH > 3
                     1'b0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        history <= 'b0;
        pulse_detected_reg <= 1'b0;
        data_out <= 1'b0;
    end
    else begin
        // Update history register
        history <= {history[PULSE_WIDTH-3:0], data_in};
        
        // Register detection for timing improvement
        pulse_detected_reg <= pulse_detected;
        
        // Output is high for one cycle when pulse pattern detected
        data_out <= pulse_detected_reg;
    end
end

endmodule