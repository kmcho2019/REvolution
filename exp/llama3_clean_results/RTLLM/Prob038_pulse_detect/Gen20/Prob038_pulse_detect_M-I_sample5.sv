module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data_in; // Register to store the previous value of data_in
reg data_out_reg; // Register to store the output

// Sequential logic to update previous value and generate output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        prev_data_in <= 1'b0;
        data_out_reg <= 1'b0;
    end else begin
        prev_data_in <= data_in;
        // Pulse detection logic: set data_out to 1 when input transitions from high to low
        if (prev_data_in == 1'b1 && data_in == 1'b0) begin
            data_out_reg <= 1'b1;
        end else begin
            data_out_reg <= 1'b0;
        end
    end
end

assign data_out = data_out_reg; // Continuous assignment for output

endmodule