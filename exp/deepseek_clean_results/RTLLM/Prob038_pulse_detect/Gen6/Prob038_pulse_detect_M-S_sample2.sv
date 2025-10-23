module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data, curr_data;  // Only need to track last two samples

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_data <= 1'b0;
        curr_data <= 1'b0;
        data_out <= 1'b0;
    end
    else begin
        // Shift current to previous, and sample new input
        prev_data <= curr_data;
        curr_data <= data_in;
        
        // Pulse detected when we see falling edge after rising edge
        data_out <= (prev_data && !curr_data && !data_out);
    end
end

endmodule