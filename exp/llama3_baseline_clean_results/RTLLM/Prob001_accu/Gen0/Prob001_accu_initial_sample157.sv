module accu(
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]   data_out
);

reg [9:0]          accu_sum;
reg [1:0]          counter;
reg               valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        accu_sum     <= 10'd0;
        counter     <= 2'd0;
        valid_out_reg <= 1'b0;
    end else begin
        if (valid_in) begin
            accu_sum <= accu_sum + data_in;
            counter <= counter + 1'b1;
        end
        if (counter == 2'd3) begin
            valid_out_reg <= 1'b1;
        end else begin
            valid_out_reg <= 1'b0;
        end
        if (valid_out_reg) begin
            accu_sum     <= 10'd0;
            counter     <= 2'd0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out  = (counter == 2'd3)? accu_sum : 10'd0;

endmodule