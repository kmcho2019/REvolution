module accu (
    input         clk,
    input         rst_n,
    input         valid_in,
    input  [7:0]  data_in,
    output        valid_out,
    output [9:0]  data_out
);

reg [9:0] accu_sum;
reg [1:0] counter;
reg        valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accu_sum <= 10'd0;
        counter <= 2'd0;
        valid_out_reg <= 1'b0;
    end else if (valid_in) begin
        if (counter == 2'd3) begin
            accu_sum <= accu_sum + data_in;
            counter <= 2'd0;
            valid_out_reg <= 1'b1;
        end else begin
            accu_sum <= accu_sum + data_in;
            counter <= counter + 1'b1;
            valid_out_reg <= 1'b0;
        end
    end else begin
        valid_out_reg <= 1'b0;
    end
end

assign valid_out = (counter == 2'd3 && valid_in)? 1'b1 : valid_out_reg;
assign data_out = (counter == 2'd3 && valid_in)? accu_sum : 10'd0;

endmodule