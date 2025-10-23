module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data_in; // Register to store the previous value of data_in

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        prev_data_in <= 0;
        data_out <= 0;
    end else begin
        prev_data_in <= data_in;
        data_out <= (prev_data_in && !data_in);
    end
end

endmodule