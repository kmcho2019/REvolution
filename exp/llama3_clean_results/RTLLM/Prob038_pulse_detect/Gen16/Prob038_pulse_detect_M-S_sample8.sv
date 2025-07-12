module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data_in; // Previous value of data_in

// Sequential logic for updating previous value and output
always @(posedge clk) begin
    if (~rst_n) begin // Synchronous reset
        prev_data_in <= 1'b0;
        data_out <= 1'b0;
    end else begin
        prev_data_in <= data_in;
        
        // Check for the sequence "010" and update data_out only when necessary
        if (prev_data_in == 1'b1 && data_in == 1'b0) begin
            data_out <= 1'b1;
        end else if (prev_data_in == 1'b0 && data_in == 1'b1) begin
            data_out <= 1'b0;
        end else if (prev_data_in == 1'b0 && data_in == 1'b0) begin
            data_out <= 1'b0;
        end else begin
            data_out <= 1'b0;
        end
    end
end

endmodule