module accu (
    input            clk,
    input            rst_n,
    input      [7:0]  data_in,
    input            valid_in,
    output           valid_out,
    output     [9:0]  data_out
);

reg     [1:0]        counter;
reg     [9:0]        sum;
reg                   valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 2'd0;
        sum     <= 10'd0;
        valid_out_reg <= 1'b0;
    end else if (valid_in) begin
        if (counter == 2'd0) begin
            sum     <= data_in;
            counter <= counter + 1;
        end else if (counter == 2'd1) begin
            sum     <= sum + data_in;
            counter <= counter + 1;
        end else if (counter == 2'd2) begin
            sum     <= sum + data_in;
            counter <= counter + 1;
        end else if (counter == 2'd3) begin
            sum     <= sum + data_in;
            counter <= 2'd0;
            valid_out_reg <= 1'b1;
        end
    end else begin
        valid_out_reg <= 1'b0;
    end
end

assign valid_out = valid_out_reg;
assign data_out  = (counter == 2'd0 && valid_out_reg) ? sum : 10'd0;

endmodule