module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

reg [7:0] data_capture_reg;
reg data_capture_flag;
reg [15:0] data_output_reg;
reg data_output_flag;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_capture_reg <= 8'b0;
        data_capture_flag <= 1'b0;
        data_output_reg <= 16'b0;
        data_output_flag <= 1'b0;
    end else begin
        if (valid_in) begin
            if (!data_capture_flag) begin
                data_capture_reg <= data_in;
                data_capture_flag <= 1'b1;
            end else begin
                data_output_reg <= {data_capture_reg, data_in};
                data_output_flag <= 1'b1;
                data_capture_flag <= 1'b0;
            end
        end
    end
end

always @(posedge clk) begin
    if (data_output_flag) begin
        valid_out <= 1'b1;
        data_out <= data_output_reg;
        data_output_flag <= 1'b0;
    end else begin
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end
end

endmodule