module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out,
    input enable // Optional enable signal (tie to 1 if unused)
);

reg [2:0] history;  // Stores last 3 samples
reg data_in_prev;   // For change detection

wire sample_enable = enable && (data_in != data_in_prev);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        history <= 3'b000;
        data_out <= 1'b0;
        data_in_prev <= 1'b0;
    end else if (enable) begin
        // Only update history when input changes (clock gating effect)
        if (sample_enable) begin
            history <= {history[1:0], data_in};
        end
        
        // Update previous value for change detection
        data_in_prev <= data_in;
        
        // Detect 010 pattern (0->1->0 transition)
        data_out <= (history == 3'b010) && enable;
    end else begin
        data_out <= 1'b0;
    end
end

endmodule