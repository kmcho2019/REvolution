module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data_in; // Register to store the previous value of data_in
reg prev_prev_data_in; // Register to store the second previous value of data_in
reg prev_prev_prev_data_in; // Register to store the third previous value of data_in

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        prev_data_in <= 1'b0;
        prev_prev_data_in <= 1'b0;
        prev_prev_prev_data_in <= 1'b0;
    end else begin
        prev_prev_prev_data_in <= prev_prev_data_in;
        prev_prev_data_in <= prev_data_in;
        prev_data_in <= data_in;
    end
end

assign data_out = (prev_prev_prev_data_in == 1'b0 && prev_prev_data_in == 1'b1 && prev_data_in == 1'b1 && data_in == 1'b0); // Set data_out to 1 when input transitions from 0 to 1 to 0 within 3 cycles

endmodule