module RAM(
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output reg [5:0] read_data
);

// Parameters
parameter WIDTH = 6;
parameter DEPTH = 8;

// RAM Array
reg [WIDTH-1:0] RAM [DEPTH-1:0];

// Initialize RAM array to all zeros
initial begin
    for (int i = 0; i < DEPTH; i++) begin
        RAM[i] = 6'b000000;
    end
end

// Write operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset: clear all memory locations
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= 6'b000000;
        end
    end else if (write_en) begin
        // Write data to RAM array at specified address
        RAM[write_addr] <= write_data;
    end
end

// Read operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset: clear read_data register
        read_data <= 6'b000000;
    end else if (read_en) begin
        // Read data from RAM array at specified address
        read_data <= RAM[read_addr];
    end else begin
        // Clear read_data register when read_en is inactive
        read_data <= 6'b000000;
    end
end

endmodule