module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

reg [7:0] data_lock_reg;
reg [15:0] data_out_reg;
reg valid_out_reg;
reg first_data_valid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock_reg <= 8'b0;
        data_out_reg <= 16'b0;
        valid_out_reg <= 1'b0;
        first_data_valid <= 1'b0;
    end else begin
        if (valid_in) begin
            if (!first_data_valid) begin
                data_lock_reg <= data_in;
                first_data_valid <= 1'b1;
            end else begin
                data_out_reg <= {data_lock_reg, data_in};
                valid_out_reg <= 1'b1;
                first_data_valid <= 1'b0;
            end
        end else begin
            valid_out_reg <= 1'b0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule