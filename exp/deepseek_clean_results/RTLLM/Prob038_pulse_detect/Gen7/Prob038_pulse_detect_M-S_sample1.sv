module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data;       // Stores previous input value
reg prev_prev_data;  // Stores value from two cycles ago

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_data <= 1'b0;
        prev_prev_data <= 1'b0;
        data_out <= 1'b0;
    end else begin
        // Check for 0->1->0 pattern
        data_out <= (!data_in && prev_data && !prev_prev_data);
        
        // Shift the history registers
        prev_prev_data <= prev_data;
        prev_data <= data_in;
    end
end

endmodule