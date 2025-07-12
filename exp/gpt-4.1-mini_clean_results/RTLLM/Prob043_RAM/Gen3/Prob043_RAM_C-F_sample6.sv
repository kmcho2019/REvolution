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
    output reg [WIDTH-1:0]  read_data
);

    reg [WIDTH-1:0] RAM [0:DEPTH-1];
    integer i;

    // RAM initialization on reset: zero all memory locations once on negedge rst_n
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
            read_data <= {WIDTH{1'b0}};
        end else begin
            // Write operation synchronous with clk and write enable
            if (write_en) begin
                RAM[write_addr] <= write_data;
            end

            // Read operation synchronous with clk and read enable
            if (read_en) begin
                read_data <= RAM[read_addr];
            end
            // When read_en is low, hold the previous read_data value to reduce toggling
        end
    end

endmodule