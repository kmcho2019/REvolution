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

// Define the RAM array with a depth of 8 and a bit width of 6 bits
reg [5:0] RAM [7:0];

// Initialize all data in the RAM array to 0
integer i;
initial begin
    for (i = 0; i < 8; i++) begin
        RAM[i] = 6'b000000;
    end
end

// Write operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // On reset, clear all memory locations in the RAM array
        for (i = 0; i < 8; i++) begin
            RAM[i] <= 6'b000000;
        end
    end else if (write_en) begin
        // Write data to the RAM array at the specified address
        RAM[write_addr] <= write_data;
    end
end

// Read operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // On reset, clear the read_data register
        read_data <= 6'b000000;
    end else if (read_en) begin
        // Read data from the RAM array at the specified address
        read_data <= RAM[read_addr];
    end else begin
        // If the read enable signal is not active, clear the read_data register
        read_data <= 6'b000000;
    end
end

endmodule