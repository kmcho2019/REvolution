module accu (
    input         clk, 
    input         rst_n, 
    input  [7:0]   data_in, 
    input         valid_in, 
    output        valid_out, 
    output [9:0]  data_out
);

reg [1:0] counter;
reg [9:0] sum_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 2'd0;
        sum_reg <= 10'd0;
    end else if (valid_in) begin
        if (counter == 2'd3) begin
            sum_reg <= sum_reg + data_in;
            counter <= 2'd0;
        end else begin
            sum_reg <= (counter == 2'd0) ? data_in : sum_reg + data_in;
            counter <= counter + 1'd1;
        end
    end
end

assign valid_out = (counter == 2'd0) && (sum_reg != 10'd0);
assign data_out = (counter == 2'd0 && sum_reg != 10'd0) ? sum_reg : 10'd0;

endmodule