module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [7:0] fifo[3:0];
reg [1:0] write_ptr;
reg [1:0] read_ptr;
reg full;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        write_ptr <= 0;
        read_ptr <= 0;
        full <= 0;
        fifo <= '{default: 0};
    end else if (valid_in) begin
        fifo[write_ptr] <= data_in;
        if (write_ptr == 3) begin
            write_ptr <= 0;
            full <= 1;
        end else begin
            write_ptr <= write_ptr + 1;
        end
    end else if (full) begin
        if (read_ptr == 3) begin
            read_ptr <= 0;
            full <= 0;
        end else begin
            read_ptr <= read_ptr + 1;
        end
    end
end

assign valid_out = full;

assign data_out = fifo[0] + fifo[1] + fifo[2] + fifo[3];

endmodule