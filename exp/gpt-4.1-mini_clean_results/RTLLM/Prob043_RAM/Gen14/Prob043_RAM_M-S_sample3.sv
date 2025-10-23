module RAM (
    input           clk,
    input           rst_n,
    input           write_en,
    input   [2:0]   write_addr,
    input   [5:0]   write_data,
    input           read_en,
    input   [2:0]   read_addr,
    output reg [5:0] read_data
);

    reg [5:0] RAM [0:7];
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize RAM contents to 0 on reset
            for (i = 0; i < 8; i = i + 1)
                RAM[i] <= 6'b0;
            read_data <= 6'b0;
        end else begin
            if (write_en)
                RAM[write_addr] <= write_data;
            if (read_en)
                read_data <= RAM[read_addr];
            else
                read_data <= 6'b0;
        end
    end

endmodule