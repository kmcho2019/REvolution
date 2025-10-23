module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [2:0] fifo_ptr;
reg [7:0] fifo_buffer;
reg [7:0] temp;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        fifo_ptr <= 3'b000;
        fifo_buffer <= 8'b00000000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        if (fifo_ptr < 3'b111) begin
            temp <= fifo_buffer;
            temp[fifo_ptr] <= din_serial;
            fifo_buffer <= temp;
            fifo_ptr <= fifo_ptr + 1'b1;
            dout_valid <= 1'b0;
        end else begin
            fifo_ptr <= 3'b000;
            dout_parallel <= fifo_buffer;
            dout_valid <= 1'b1;
        end
    end else begin
        fifo_ptr <= fifo_ptr;
        fifo_buffer <= fifo_buffer;
        dout_parallel <= dout_parallel;
        dout_valid <= (fifo_ptr == 3'b111)? 1'b1 : 1'b0;
    end
end

endmodule