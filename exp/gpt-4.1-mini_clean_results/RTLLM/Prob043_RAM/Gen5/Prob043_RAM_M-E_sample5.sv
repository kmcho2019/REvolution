module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
)(
    input                   clk,
    input                   rst_n,
    input                   write_en,
    input      [$clog2(DEPTH)-1:0] write_addr,
    input      [WIDTH-1:0]  write_data,
    input                   read_en,
    input      [$clog2(DEPTH)-1:0] read_addr,
    output reg [WIDTH-1:0]  read_data
);

    reg [WIDTH-1:0] RAM [0:DEPTH-1];
    integer i;

    // Asynchronous reset initializes RAM to zero
    always @(negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
        end
    end

    // Synchronous write operation on posedge clk
    always @(posedge clk) begin
        if (write_en)
            RAM[write_addr] <= write_data;
    end

    // Synchronous read operation on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            read_data <= {WIDTH{1'b0}};
        else if (read_en)
            read_data <= RAM[read_addr];
        // else retain previous read_data value (no clearing)
    end

endmodule