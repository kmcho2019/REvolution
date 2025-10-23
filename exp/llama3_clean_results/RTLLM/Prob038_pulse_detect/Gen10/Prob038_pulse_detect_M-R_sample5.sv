module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data;
reg prev_prev_data;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_data <= 0;
        prev_prev_data <= 0;
        data_out <= 0;
    end else begin
        prev_prev_data <= prev_data;
        prev_data <= data_in;
        data_out <= (prev_prev_data == 1 && prev_data == 0 && data_in == 0);
    end
end

endmodule