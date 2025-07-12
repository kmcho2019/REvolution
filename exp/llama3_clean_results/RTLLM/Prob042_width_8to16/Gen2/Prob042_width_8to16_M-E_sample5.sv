module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [7:0] fifo [1:0];
reg [1:0] fifo_ptr;
reg [1:0] fifo_cnt;
reg       fifo_full;
reg       fifo_empty;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fifo_ptr  <= 2'd0;
        fifo_cnt  <= 2'd0;
        fifo_full <= 1'b0;
        fifo_empty <= 1'b1;
        valid_out <= 1'b0;
        data_out  <= 16'd0;
    end
    else begin
        if (valid_in && !fifo_full) begin
            fifo[fifo_ptr] <= data_in;
            fifo_ptr <= fifo_ptr + 1;
            fifo_cnt <= fifo_cnt + 1;
            if (fifo_cnt == 2) begin
                fifo_full <= 1'b1;
            end
        end
        if (fifo_full) begin
            data_out  <= {fifo[1], fifo[0]};
            valid_out <= 1'b1;
            fifo_ptr  <= 2'd0;
            fifo_cnt  <= 2'd0;
            fifo_full <= 1'b0;
        end
        else begin
            valid_out <= 1'b0;
        end
    end
end

endmodule