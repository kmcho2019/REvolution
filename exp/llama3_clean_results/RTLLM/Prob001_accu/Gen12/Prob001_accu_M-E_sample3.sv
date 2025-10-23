module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [7:0] fifo [3:0]; // 4-stage FIFO
reg [1:0] fifo_ptr; // FIFO pointer
reg [9:0] sum; // sum register
reg valid_out_reg; // valid_out register

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fifo_ptr <= 0;
        sum <= 0;
        valid_out_reg <= 0;
        for (int i = 0; i < 4; i++) begin
            fifo[i] <= 0;
        end
    end else begin
        if (valid_in) begin
            // shift data into FIFO
            for (int i = 3; i > 0; i--) begin
                fifo[i] <= fifo[i-1];
            end
            fifo[0] <= data_in;
            fifo_ptr <= fifo_ptr + 1;
        end

        // calculate sum when FIFO is full
        if (fifo_ptr == 4) begin
            sum <= fifo[0] + fifo[1] + fifo[2] + fifo[3];
            valid_out_reg <= 1;
            fifo_ptr <= 0; // reset FIFO pointer
        end else begin
            valid_out_reg <= 0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = sum;

endmodule