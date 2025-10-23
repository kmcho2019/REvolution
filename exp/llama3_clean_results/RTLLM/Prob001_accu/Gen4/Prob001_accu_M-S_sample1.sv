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

always @(posedge clk) begin
    if (~rst_n) begin
        accu_sum <= 10'd0;
        counter <= 2'd0;
    end else if (valid_in) begin
        accu_sum <= accu_sum + data_in;
        counter <= counter + 1'd1;
    end
    
    if (counter == 2'd3) begin
        counter <= 2'd0;
    end
end

assign valid_out = (counter == 2'd3);
assign data_out = (valid_out) ? accu_sum : 10'd0;

endmodule