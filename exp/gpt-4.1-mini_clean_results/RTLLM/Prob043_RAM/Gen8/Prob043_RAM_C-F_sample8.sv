module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
)(
    input                           clk,
    input                           rst_n,         // active low reset
    input                           write_en,
    input      [$clog2(DEPTH)-1:0] write_addr,
    input      [WIDTH-1:0]          write_data,
    input                           read_en,
    input      [$clog2(DEPTH)-1:0] read_addr,
    output reg [WIDTH-1:0]          read_data
);

    // RAM memory array: DEPTH locations of WIDTH bits each
    reg [WIDTH-1:0] RAM [0:DEPTH-1];

    // Initialize RAM contents to zero at elaboration/startup
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            RAM[i] = {WIDTH{1'b0}};
        end
    end

    // Synchronous write and synchronous read_data register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // On reset, clear read_data output
            read_data <= {WIDTH{1'b0}};
        end else begin
            // Write operation
            if (write_en) begin
                RAM[write_addr] <= write_data;
            end
            // Read operation - synchronous read with read_en gating
            if (read_en) begin
                read_data <= RAM[read_addr];
            end else begin
                read_data <= {WIDTH{1'b0}};
            end
        end
    end

endmodule