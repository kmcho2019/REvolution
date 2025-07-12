module width_8to16(
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [7:0] data_lock;
reg [7:0] data_temp;
reg       flag;
reg       valid_temp;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 16'd0;
        flag     <= 1'b0;
        valid_temp <= 1'b0;
        data_temp  <= 8'd0;
    end else if (valid_in) begin
        if (!flag) begin
            // Store the first valid data and set flag
            data_temp <= data_in;
            flag     <= 1'b1;
        end else begin
            // Concatenate the stored data with the new data
            data_lock <= data_temp;
            data_out  <= {data_lock, data_in};
            valid_temp <= 1'b1;
            flag     <= 1'b0;
        end
    end
end

assign valid_out = valid_temp;

always @(posedge clk) begin
    valid_temp <= 1'b0;
end

endmodule