module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

// FIFO module with a depth of 2
reg [7:0] fifo [1:0];
reg [1:0] wr_ptr;
reg [1:0] rd_ptr;
reg [1:0] occupancy;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wr_ptr  <= 2'd0;
        rd_ptr  <= 2'd0;
        occupancy <= 2'd0;
    end
    else begin
        if (valid_in) begin
            fifo[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
            occupancy <= occupancy + 1;
        end

        if (occupancy == 2) begin
            data_out <= {fifo[rd_ptr], fifo[(rd_ptr + 1) % 2]};
            valid_out <= 1'b1;
            rd_ptr <= rd_ptr + 1;
            occupancy <= occupancy - 1;
        end
        else begin
            valid_out <= 1'b0;
        end
    end
end

endmodule