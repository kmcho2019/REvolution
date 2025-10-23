module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
)(
    input                           clk,
    input                           rst_n,
    input                           write_en,
    input      [$clog2(DEPTH)-1:0] write_addr,
    input      [WIDTH-1:0]          write_data,
    input                           read_en,
    input      [$clog2(DEPTH)-1:0] read_addr,
    output reg [WIDTH-1:0]          read_data
);

    // Memory array declaration
    reg [WIDTH-1:0] RAM [0:DEPTH-1];
    integer i;

    // Synchronous reset and write process
    // On reset, clear all RAM locations to zero synchronously
    // On write_en asserted, write write_data to RAM at write_addr
    always @(posedge clk) begin
        if (!rst_n) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
        end else if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end

    // Synchronous read process with registered output
    // On reset, clear read_data to zero
    // When read_en asserted, read data from RAM at read_addr on clock edge
    // Otherwise output zero
    always @(posedge clk) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end else if (read_en) begin
            read_data <= RAM[read_addr];
        end else begin
            read_data <= {WIDTH{1'b0}};
        end
    end

endmodule