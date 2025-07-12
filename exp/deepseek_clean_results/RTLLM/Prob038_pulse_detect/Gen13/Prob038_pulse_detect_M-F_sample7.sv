module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Stores the last two samples of data_in
reg [1:0] history;  
// Pulse is detected when we see 1->0 transition after 0->1
wire pulse_detected = (history == 2'b10) && (data_in == 1'b0);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset clears history and output
        history <= 2'b00;
        data_out <= 1'b0;
    end
    else begin
        // Shift in new sample (oldest sample drops out)
        history <= {history[0], data_in};
        
        // Output is high for one cycle when pulse pattern detected
        data_out <= pulse_detected;
    end
end

endmodule