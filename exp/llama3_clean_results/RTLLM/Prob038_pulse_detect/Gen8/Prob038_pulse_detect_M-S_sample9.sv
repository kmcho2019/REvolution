module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data_in; // Register to hold the previous value of data_in

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        prev_data_in <= 1'b0; // Reset previous data_in to 0
        data_out <= 1'b0; // Reset output to 0
    end else begin
        if (prev_data_in == 1'b1 && data_in == 1'b0) begin
            // If previous data_in was 1 and current data_in is 0, it's the end of a pulse
            data_out <= 1'b1; // Set output to 1
        end else begin
            data_out <= 1'b0; // Otherwise, output is 0
        end
        prev_data_in <= data_in; // Update previous data_in
    end
end

endmodule