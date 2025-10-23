module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_capture_reg;
reg first_data_captured;

assign valid_out = first_data_captured && valid_in;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_capture_reg <= 8'b0;
        first_data_captured <= 1'b0;
        data_out <= 16'b0;
    end else begin
        if (valid_in) begin
            if (!first_data_captured) begin
                data_capture_reg <= data_in;
                first_data_captured <= 1'b1;
            end else begin
                data_out <= {data_capture_reg, data_in};
                first_data_captured <= 1'b0;
            end
        end else begin
            first_data_captured <= first_data_captured;
        end
    end
end

endmodule