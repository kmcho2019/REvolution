module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

reg [7:0] data_lock;
reg flag;
reg [15:0] data_out_reg;
reg valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out_reg <= 0;
        valid_out_reg <= 0;
        flag <= 0;
        data_lock <= 0;
    end else if (valid_in) begin
        if (!flag) begin
            data_lock <= data_in;
            flag <= 1;
        end else begin
            data_out_reg <= {data_lock, data_in};
            valid_out_reg <= 1;
            flag <= 0;
        end
    end else begin
        valid_out_reg <= 0;
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule