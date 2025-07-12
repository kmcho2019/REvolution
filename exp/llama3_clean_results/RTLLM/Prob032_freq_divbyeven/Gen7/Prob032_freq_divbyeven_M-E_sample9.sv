module freq_diveven #(
    parameter NUM_DIV = 8  // Must be an even number
)(
    input  clk,    // Input clock signal
    input  rst_n,  // Active-low reset signal
    output reg clk_div  // Divided clock output signal
);

reg [7:0] phase_detector_out; // Phase detector output
reg [7:0] loop_filter_out; // Loop filter output
reg [7:0] vco_out; // VCO output
reg [7:0] feedback_out; // Feedback output

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        phase_detector_out <= 8'b0;
        loop_filter_out <= 8'b0;
        vco_out <= 8'b0;
        feedback_out <= 8'b0;
        clk_div <= 1'b0;
    end else begin
        // Phase detector
        phase_detector_out <= (phase_detector_out + (NUM_DIV / 2)) % NUM_DIV;
        
        // Loop filter
        loop_filter_out <= loop_filter_out + phase_detector_out;
        
        // VCO
        vco_out <= (vco_out + loop_filter_out) % NUM_DIV;
        
        // Feedback
        feedback_out <= vco_out;
        
        // Divide clock output
        if (feedback_out == (NUM_DIV / 2 - 1)) begin
            clk_div <= ~clk_div;
        end
    end
end

endmodule