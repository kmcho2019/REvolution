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
        sum <= 10'd0;
        count <= 2'd0;
        valid_out_reg <= 1'b0;
    end else if (valid_in) begin
        if (count < 2'd3) begin
            sum <= sum + {{2{data_in[7]}}, data_in};
            count <= count + 1'd1;
            valid_out_reg <= 1'b0;
        end else begin
            sum <= sum + {{2{data_in[7]}}, data_in};
            valid_out_reg <= 1'b1;
            count <= 2'd0;
        end
    end else begin
        valid_out_reg <= 1'b0;
    end
end

assign valid_out = valid_out_reg;
assign data_out = (count == 2'd3 && valid_in) ? sum : 10'd0;

endmodule