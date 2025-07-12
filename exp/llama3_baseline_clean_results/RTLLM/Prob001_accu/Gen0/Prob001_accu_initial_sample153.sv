module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [9:0] sum;
reg [1:0] count;
reg valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 0;
        count <= 0;
        valid_out_reg <= 0;
    end else if (valid_in) begin
        if (count < 4) begin
            sum <= sum + data_in;
            count <= count + 1;
            valid_out_reg <= 0;
        end else if (count == 4) begin
            count <= 0;
            valid_out_reg <= 1;
        end
    end else begin
        valid_out_reg <= 0;
    end
end

assign valid_out = valid_out_reg;
assign data_out = (valid_out_reg) ? sum : 0;

endmodule