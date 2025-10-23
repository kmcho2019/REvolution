module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg data_in_prev;
wire rising_edge;
wire falling_edge;
reg rising_edge_pulse;

// Edge detection
assign rising_edge = ~data_in_prev & data_in;
assign falling_edge = data_in_prev & ~data_in;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_in_prev <= 1'b0;
        rising_edge_pulse <= 1'b0;
        data_out <= 1'b0;
    end else begin
        // Store previous input for edge detection
        data_in_prev <= data_in;
        
        // Create a 1-cycle delayed pulse for rising edge
        rising_edge_pulse <= rising_edge;
        
        // Output is high when we get falling edge during active rising pulse
        data_out <= falling_edge & rising_edge_pulse;
    end
end

endmodule