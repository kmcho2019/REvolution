module RAM (
    input              clk,
    input              rst_n,
    input              write_en,
    input       [2:0]  write_addr,  // 3 bits for DEPTH=8
    input       [5:0]  write_data,  // WIDTH=6
    input              read_en,
    input       [2:0]  read_addr,
    output reg  [5:0]  read_data
);

    reg [5:0] RAM [0:7];
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
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