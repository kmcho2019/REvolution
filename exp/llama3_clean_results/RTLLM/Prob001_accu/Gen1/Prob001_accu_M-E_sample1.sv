module accu (
    input             clk,
    input             rst_n,
    input      [7:0]  data_in,
    input             valid_in,
    output            valid_out,
    output     [9:0]  data_out
);

reg     [9:0]  data_out_reg;
reg             valid_out_reg;
reg     [1:0]  fifo_ptr;
reg     [7:0]  fifo_buf [3:0];
reg     [9:0]  accu_reg;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out_reg <= 1'b0;
        data_out_reg <= 10'd0;
        fifo_ptr <= 2'd0;
        accu_reg <= 10'd0;
        for (int i = 0; i < 4; i++) begin
            fifo_buf[i] <= 8'd0;
        end
    end else begin
        if (valid_in) begin
            fifo_buf[fifo_ptr] <= data_in;
            if (fifo_ptr == 2'd3) begin
                accu_reg <= fifo_buf[0] + fifo_buf[1] + fifo_buf[2] + fifo_buf[3];
                valid_out_reg <= 1'b1;
                data_out_reg <= accu_reg;
                fifo_ptr <= 2'd0;
            end else begin
                fifo_ptr <= fifo_ptr + 1'd1;
                valid_out_reg <= 1'b0;
            end
        end else begin
            valid_out_reg <= 1'b0;
            if (fifo_ptr == 2'd0) begin
                data_out_reg <= 10'd0;
            end
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule