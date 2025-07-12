module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] cnt;
reg [9:0] sum;
reg valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
    end else if (valid_in) begin
        cnt <= cnt + 1;
    end else begin
        cnt <= 0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum <= 0;
        valid_out_reg <= 0;
    end else if (cnt == 3 && valid_in) begin
        sum <= sum + data_in;
        valid_out_reg <= 1;
    end else if (cnt == 0 && valid_in) begin
        sum <= data_in;
        valid_out_reg <= 0;
    end else if (cnt < 3 && valid_in) begin
        sum <= sum + data_in;
        valid_out_reg <= 0;
    end else begin
        valid_out_reg <= 0;
    end
end

assign valid_out = valid_out_reg;
assign data_out = sum;

endmodule