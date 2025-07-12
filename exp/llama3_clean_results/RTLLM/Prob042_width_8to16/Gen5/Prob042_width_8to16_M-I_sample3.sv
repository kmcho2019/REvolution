module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

reg [7:0] data_first;
reg [7:0] data_second;
reg valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_first <= 0;
        data_second <= 0;
        valid_out_reg <= 0;
    end else begin
        if (valid_in) begin
            if (data_first == 0) begin
                data_first <= data_in;
            end else begin
                data_second <= data_in;
                valid_out_reg <= 1;
            end
        end else begin
            valid_out_reg <= 0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = {data_first, data_second};

endmodule