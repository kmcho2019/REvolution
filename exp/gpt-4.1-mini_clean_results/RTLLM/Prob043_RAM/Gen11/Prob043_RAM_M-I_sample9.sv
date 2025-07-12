module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
)(
    input                         clk,
    input                         rst_n,
    input                         write_en,
    input      [$clog2(DEPTH)-1:0] write_addr,
    input      [WIDTH-1:0]        write_data,
    input                         read_en,
    input      [$clog2(DEPTH)-1:0] read_addr,
    output reg [WIDTH-1:0]        read_data
);

    reg [WIDTH-1:0] RAM [0:DEPTH-1];

    // Synchronous write operation
    always @(posedge clk) begin
        if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end

    // Registered synchronous read operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end else begin
            // Output data from RAM at read_addr every cycle regardless of read_en
            // If read_en is low, output still valid but user can ignore
            read_data <= RAM[read_addr];
        end
    end

endmodule