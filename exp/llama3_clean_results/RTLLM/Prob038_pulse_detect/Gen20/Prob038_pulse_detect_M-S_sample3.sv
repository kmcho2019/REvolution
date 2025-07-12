module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data_in; // Register to store the previous value of data_in
reg prev_prev_data_in; // Register to store the value before prev_data_in

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        prev_data_in <= 0;
        prev_prev_data_in <= 0;
        data_out <= 0;
    end else begin
        prev_prev_data_in <= prev_data_in;
        prev_data_in <= data_in;
        if (prev_prev_data_in == 1'b0 && prev_data_in == 1'b1 && data_in == 1'b0) begin // Pulse detected
            data_out <= 1'b1;
        end else begin
            data_out <= 1'b0;
        end
    end
end

endmodule