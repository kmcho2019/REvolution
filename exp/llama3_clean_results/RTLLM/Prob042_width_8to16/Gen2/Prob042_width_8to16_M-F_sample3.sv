module width_8to16 (
    input         clk,
    input         rst_n,
    input         valid_in,
    input  [7:0]  data_in,
    output        valid_out,
    output [15:0] data_out
);

reg [7:0]  fifo [1:0];
reg [1:0]  fifo_cnt;
reg         valid_out_reg;
reg [15:0] data_out_reg;
reg         partial_fill;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fifo_cnt <= 2'b00;
        valid_out_reg <= 1'b0;
        data_out_reg <= 16'd0;
        partial_fill <= 1'b0;
    end else begin
        // FIFO operations
        if (valid_in && fifo_cnt < 2'b10) begin
            if (fifo_cnt == 2'b01) begin
                fifo[1] <= data_in;
                fifo_cnt <= fifo_cnt + 1'b1;
                partial_fill <= 1'b0;
            end else if (fifo_cnt == 2'b00) begin
                fifo[0] <= data_in;
                fifo_cnt <= fifo_cnt + 1'b1;
                partial_fill <= 1'b1;
            end
        end
        
        // Check if FIFO is full and generate output
        if (fifo_cnt == 2'b10) begin
            data_out_reg <= {fifo[1], fifo[0]};
            valid_out_reg <= 1'b1;
            fifo_cnt <= 2'b00;
            partial_fill <= 1'b0;
        end else begin
            valid_out_reg <= 1'b0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out  = data_out_reg;

endmodule