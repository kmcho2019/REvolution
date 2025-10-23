module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

// FIFO module
reg [7:0] fifo_data;
reg [2:0] fifo_cnt;
reg fifo_empty;
reg fifo_full;

// Control signals
reg fifo_write;
reg fifo_read;

// Counter
reg [2:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        fifo_cnt <= 3'b000;
        fifo_data <= 8'b00000000;
        fifo_empty <= 1'b1;
        fifo_full <= 1'b0;
        cnt <= 3'b000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else begin
        // Write to FIFO
        if (din_valid &&!fifo_full) begin
            fifo_write <= 1'b1;
            fifo_data <= {fifo_data[6:0], din_serial};
            fifo_cnt <= fifo_cnt + 1'b1;
            fifo_empty <= 1'b0;
            cnt <= cnt + 1'b1;
            if (fifo_cnt == 3'b111) begin
                fifo_full <= 1'b1;
            end
        end else begin
            fifo_write <= 1'b0;
        end

        // Read from FIFO
        if (fifo_full &&!din_valid) begin
            fifo_read <= 1'b1;
            dout_parallel <= fifo_data;
            dout_valid <= 1'b1;
            fifo_full <= 1'b0;
            fifo_cnt <= 3'b000;
            fifo_empty <= 1'b1;
        end else begin
            fifo_read <= 1'b0;
            if (~din_valid && fifo_empty) begin
                dout_valid <= 1'b0;
            end
        end
    end
end

endmodule