module accu (
    input         clk, 
    input         rst_n, 
    input  [7:0]   data_in, 
    input         valid_in, 
    output        valid_out, 
    output [9:0]  data_out
);

reg [1:0] cnt_reg;
reg [9:0] sum_reg;
reg        valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_reg <= 2'd0;
        sum_reg <= 10'd0;
        valid_out_reg <= 1'b0;
    end else if (valid_in) begin
        sum_reg <= (cnt_reg == 2'd0) ? data_in : sum_reg + data_in;
        cnt_reg <= (cnt_reg == 2'd3) ? 2'd0 : cnt_reg + 1'd1;
        valid_out_reg <= (cnt_reg == 2'd0) ? 1'b1 : 1'b0;
    end
end

assign valid_out = valid_out_reg;
assign data_out = (valid_out_reg) ? sum_reg : 10'd0;

endmodule