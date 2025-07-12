module accu (
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
    if (!rst_n) begin
        sum <= 10'd0;
        count <= 2'd0;
        valid_out_reg <= 1'b0;
    end else if (valid_in) begin
        sum <= sum + data_in;
        count <= count + 1'b1;
        if (count == 2'd3) begin
            valid_out_reg <= 1'b1;
        end else begin
            valid_out_reg <= 1'b0;
        end
    end else if (valid_out_reg) begin
        sum <= 10'd0;
        count <= 2'd0;
        valid_out_reg <= 1'b0;
    end
end

assign valid_out = valid_out_reg;
assign data_out = sum;

endmodule