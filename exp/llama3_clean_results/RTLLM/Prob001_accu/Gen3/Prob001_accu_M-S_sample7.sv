module accu (
    input         clk, 
    input         rst_n, 
    input  [7:0]   data_in, 
    input         valid_in, 
    output        valid_out, 
    output [9:0]  data_out
);

reg [9:0] accu_sum;
reg [1:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accu_sum <= 10'd0;
        counter <= 2'd0;
    end else if (valid_in) begin
        accu_sum <= (counter == 2'd0) ? data_in : accu_sum + data_in;
        counter <= (counter == 2'd3) ? 2'd0 : counter + 1'd1;
    end
end

assign valid_out = (counter == 2'd3) && valid_in;
assign data_out = (valid_out) ? accu_sum : 10'd0;

endmodule