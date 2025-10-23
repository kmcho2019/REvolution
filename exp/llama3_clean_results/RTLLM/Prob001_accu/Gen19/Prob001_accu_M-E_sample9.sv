module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [7:0] fifo[3:0];
reg [1:0] fifo_ptr;
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fifo_ptr <= 0;
        sum <= 0;
    end else begin
        if (valid_in) begin
            fifo[fifo_ptr] <= data_in;
            fifo_ptr <= fifo_ptr + 1;
            if (fifo_ptr == 4) begin
                sum <= fifo[0] + fifo[1] + fifo[2] + fifo[3];
                fifo_ptr <= 0;
            end
        end
    end
end

assign valid_out = (fifo_ptr == 0) && (sum!= 0);
assign data_out = sum;

endmodule