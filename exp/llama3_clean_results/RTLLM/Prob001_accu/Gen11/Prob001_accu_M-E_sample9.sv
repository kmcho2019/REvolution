module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [7:0] fifo [3:0];
reg [1:0] fifo_ptr;
reg [9:0] sum;
reg valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fifo_ptr <= 0;
        sum <= 0;
        valid_out_reg <= 0;
    end else if (valid_in) begin
        fifo[fifo_ptr] <= data_in;
        fifo_ptr <= (fifo_ptr + 1) % 4;
        if (fifo_ptr == 0) begin
            sum <= fifo[0] + fifo[1] + fifo[2] + fifo[3];
            valid_out_reg <= 1;
        end else begin
            valid_out_reg <= 0;
        end
    end else begin
        valid_out_reg <= 0;
    end
end

assign valid_out = valid_out_reg;
assign data_out = sum;

endmodule