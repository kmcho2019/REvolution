module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] fifo [1:0]; // FIFO buffer with depth 2
reg [1:0] fifo_ptr; // FIFO pointer
reg [1:0] fifo_cnt; // FIFO count

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fifo_ptr <= 0;
        fifo_cnt <= 0;
        valid_out <= 0;
        data_out <= 16'b0;
    end else begin
        if (valid_in) begin
            if (fifo_cnt < 2) begin
                fifo[fifo_ptr] <= data_in;
                fifo_ptr <= fifo_ptr + 1;
                fifo_cnt <= fifo_cnt + 1;
            end
            if (fifo_cnt == 2) begin
                data_out <= {fifo[1], fifo[0]};
                valid_out <= 1;
                fifo_ptr <= 0;
                fifo_cnt <= 0;
            end
        end else begin
            valid_out <= 0;
        end
    end
end

endmodule