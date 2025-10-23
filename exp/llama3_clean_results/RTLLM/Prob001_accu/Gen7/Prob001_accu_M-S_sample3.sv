module accu (
    input         clk, 
    input         rst_n, 
    input  [7:0]   data_in, 
    input         valid_in, 
    output        valid_out, 
    output [9:0]  data_out
);

reg [9:0] sum_reg;
reg [1:0] cnt_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg <= 10'd0;
        cnt_reg <= 2'd0;
    end else begin
        if (valid_in) begin
            sum_reg <= sum_reg + data_in;
            cnt_reg <= cnt_reg + 1'd1;
            if (cnt_reg == 2'd3) begin
                cnt_reg <= 2'd0;
            end
        end else begin
            // No action when valid_in is 0
        end
    end
end

assign valid_out = (cnt_reg == 2'd0 && sum_reg != 10'd0);
assign data_out = (valid_out) ? sum_reg : 10'd0;

endmodule