module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg data_delay1;
reg data_delay2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        data_delay1 <= 1'b0;
        data_delay2 <= 1'b0;
    end else begin
        data_delay2 <= data_delay1;
        data_delay1 <= data_in;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        data_out <= 1'b0;
    end else begin
        if (data_delay2 == 1'b1 && data_delay1 == 1'b0 && data_in == 1'b0) begin
            data_out <= 1'b1;
        end else begin
            data_out <= 1'b0;
        end
    end
end

endmodule