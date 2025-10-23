module RAM(
    clk,
    rst_n,
    write_en,
    write_addr,
    write_data,
    read_en,
    read_addr,
    read_data
);

parameter WIDTH = 6;
parameter DEPTH = 8;

reg [WIDTH-1:0] RAM [DEPTH-1:0];
reg [WIDTH-1:0] read_data;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < DEPTH; i++) begin
            RAM[i] <= 0;
        end
    end else if (write_en) begin
        RAM[write_addr] <= write_data;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        read_data <= 0;
    end else if (read_en) begin
        read_data <= RAM[read_addr];
    end else begin
        read_data <= 0;
    end
end

endmodule