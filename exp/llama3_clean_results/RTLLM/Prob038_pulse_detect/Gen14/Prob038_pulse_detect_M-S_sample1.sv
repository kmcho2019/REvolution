module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data_in; // Previous value of data_in
reg prev_prev_data_in; // Value of data_in before previous one

// Sequential logic for updating previous values
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        prev_data_in <= 1'b0;
        prev_prev_data_in <= 1'b0;
        data_out <= 1'b0;
    end else begin
        prev_prev_data_in <= prev_data_in;
        prev_data_in <= data_in;
        
        // Check for the sequence "010"
        if (prev_prev_data_in == 1'b0 && prev_data_in == 1'b1 && data_in == 1'b0) begin
            data_out <= 1'b1;
        end else begin
            data_out <= 1'b0;
        end
    end
end

endmodule