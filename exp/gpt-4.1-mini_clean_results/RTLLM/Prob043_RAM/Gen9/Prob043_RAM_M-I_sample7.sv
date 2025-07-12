module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input                   clk,
    input                   rst_n,
    input                   write_en,
    input      [ADDR_WIDTH-1:0] write_addr,
    input      [WIDTH-1:0]  write_data,
    input                   read_en,
    input      [ADDR_WIDTH-1:0] read_addr,
    output reg [WIDTH-1:0]  read_data
);

    // RAM memory array, initialized to zeros by synthesis tool or external file
    reg [WIDTH-1:0] RAM [0:DEPTH-1];

    integer i;

    // Synchronous write operation (no synchronous reset to RAM contents)
    always @(posedge clk) begin
        if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end

    // Synchronous read operation with read enable and synchronous reset of read_data output only
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end else if (read_en) begin
            read_data <= RAM[read_addr];
        end else begin
            read_data <= {WIDTH{1'b0}};
        end
    end

endmodule