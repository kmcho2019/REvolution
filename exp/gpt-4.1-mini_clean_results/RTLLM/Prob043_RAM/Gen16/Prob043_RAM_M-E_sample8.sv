module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input                   clk,
    input                   rst_n,
    input                   write_en,
    input  [ADDR_WIDTH-1:0] write_addr,
    input  [WIDTH-1:0]      write_data,
    input                   read_en,
    input  [ADDR_WIDTH-1:0] read_addr,
    output [WIDTH-1:0]      read_data
);

    reg [WIDTH-1:0] RAM [0:DEPTH-1];

    integer idx;

    // Synchronous reset to initialize RAM to zeros
    always @(posedge clk) begin
        if (!rst_n) begin
            for (idx = 0; idx < DEPTH; idx = idx + 1) begin
                RAM[idx] <= {WIDTH{1'b0}};
            end
        end
    end

    // Synchronous write operation
    always @(posedge clk) begin
        if (rst_n && write_en) begin
            RAM[write_addr] <= write_data;
        end
    end

    // Asynchronous combinational read with gating by read_en
    assign read_data = (read_en) ? RAM[read_addr] : {WIDTH{1'b0}};

endmodule