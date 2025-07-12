module accu(
    input         clk,
    input         rst_n,
    input  [7:0]  data_in,
    input         valid_in,
    output        valid_out,
    output [9:0]  data_out
);

reg [1:0] counter;
reg [9:0] accu_sum;
reg        valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 2'd0;
        accu_sum <= 10'd0;
        valid_out_reg <= 1'b0;
    end else begin
        if (valid_in) begin
            if (counter == 4'd3) begin
                counter <= 2'd0;
                valid_out_reg <= 1'b1;
            end else begin
                counter <= counter + 1'b1;
                valid_out_reg <= 1'b0;
            end
            accu_sum <= (counter == 4'd0) ? data_in : accu_sum + data_in;
        end else begin
            counter <= counter;
            accu_sum <= accu_sum;
            valid_out_reg <= 1'b0;
        end
    end
end

assign valid_out = (valid_out_reg == 1'b1 && counter == 4'd0) ? 1'b1 : 1'b0;
assign data_out = accu_sum;

endmodule