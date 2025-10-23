module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH  = 8
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

    // RAM array: DEPTH words, each WIDTH bits wide
    reg [WIDTH-1:0] RAM [0:DEPTH-1];
    integer i;

    // Synchronous reset and write operation
    always @(posedge clk) begin
        if (!rst_n) begin
            // Initialize all RAM entries to zero on reset
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
        end else if (write_en) begin
            // Write data to RAM at write_addr on write enable
            RAM[write_addr] <= write_data;
        end
    end

    // Synchronous read operation with read enable gating
    always @(posedge clk) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end else if (read_en) begin
            // Output RAM data at read_addr when read_en is asserted
            read_data <= RAM[read_addr];
        end else begin
            // Output zero when read_en is deasserted
            read_data <= {WIDTH{1'b0}};
        end
    end

endmodule