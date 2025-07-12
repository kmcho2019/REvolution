module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

reg [7:0] data_lock;
reg valid_flag;
reg [15:0] data_out_reg;
reg valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock <= 0;
        valid_flag <= 0;
        valid_out_reg <= 0;
        data_out_reg <= 0;
    end else begin
        if (valid_in) begin
            if (!valid_flag) begin
                data_lock <= data_in;
                valid_flag <= 1;
            end else begin
                data_out_reg <= {data_lock, data_in};
                valid_out_reg <= 1;
                valid_flag <= 0;
            end
        end else begin
            valid_out_reg <= 0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule