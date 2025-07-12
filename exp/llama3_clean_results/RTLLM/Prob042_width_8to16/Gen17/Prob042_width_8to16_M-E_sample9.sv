module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] fifo_buffer [1:0];
reg [1:0] fifo_ptr;
reg fifo_full;
reg fifo_empty;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fifo_ptr <= 2'b00;
        fifo_full <= 1'b0;
        fifo_empty <= 1'b1;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0;
        if (valid_in && !fifo_full) begin
            fifo_buffer[fifo_ptr] <= data_in;
            fifo_ptr <= fifo_ptr + 1;
            if (fifo_ptr == 2) begin
                fifo_full <= 1'b1;
                fifo_empty <= 1'b0;
            end
        end
        if (fifo_full) begin
            data_out <= {fifo_buffer[1], fifo_buffer[0]};
            valid_out <= 1'b1;
            fifo_full <= 1'b0;
            fifo_ptr <= 2'b00;
            fifo_empty <= 1'b1;
        end
    end
end

endmodule