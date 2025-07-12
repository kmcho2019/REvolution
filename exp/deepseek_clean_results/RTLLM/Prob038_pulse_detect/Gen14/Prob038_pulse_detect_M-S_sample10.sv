module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg saw_rise;  // tracks if we saw a rising edge

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        saw_rise <= 1'b0;
        data_out <= 1'b0;
    end
    else begin
        // Detect falling edge after rising edge
        data_out <= saw_rise & ~data_in;
        
        // Update rise detection
        saw_rise <= data_in;
    end
end

endmodule