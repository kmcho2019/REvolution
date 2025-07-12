module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_capture_reg;
reg data_capture_flag;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_capture_reg <= 8'b0;
        data_capture_flag <= 1'b0;
    end else begin
        if (valid_in && !data_capture_flag) begin
            data_capture_reg <= data_in;
            data_capture_flag <= 1'b1;
        end else if (valid_in && data_capture_flag) begin
            data_capture_flag <= 1'b0;
        end
    end
end

assign valid_out = (data_capture_flag && valid_in);
assign data_out = {data_capture_reg, data_in};

endmodule