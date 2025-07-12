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
reg        valid_out_reg;

always @(posedge clk) begin
    if (~rst_n) begin
        accu_sum <= 10'd0;
        counter <= 2'd0;
        valid_out_reg <= 1'b0;
    end else begin
        if (valid_in) begin
            accu_sum <= accu_sum + data_in;
            counter <= counter + 1'd1;
            if (counter == 2'd3) begin
                valid_out_reg <= 1'b1;
                counter <= 2'd0;
            end
        end else begin
            // No action when valid_in is 0
        end
        if (valid_out_reg) begin
            valid_out_reg <= 1'b0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = (valid_out_reg) ? accu_sum : 10'd0;

endmodule