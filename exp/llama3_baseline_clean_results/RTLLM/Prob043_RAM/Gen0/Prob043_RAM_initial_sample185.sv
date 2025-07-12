module RAM(
    input         clk,
    input         rst_n,
    input         write_en,
    input  [2:0]  write_addr,
    input  [5:0]  write_data,
    input         read_en,
    input  [2:0]  read_addr,
    output [5:0]  read_data
);

// Define parameters for the width and depth of the RAM
parameter WIDTH = 6;
parameter DEPTH = 8;

// Define the RAM array with 2^WIDTH locations, each with a width of WIDTH bits
reg [WIDTH-1:0] RAM [DEPTH-1:0];

// Initialize the RAM array with all zeros
initial begin
    for (int i = 0; i < DEPTH; i++) begin
        RAM[i] = 6'b000000;
    end
end

// Always block for write operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the RAM array
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= 6'b000000;
        end
    end else if (write_en) begin
        // Write data to the RAM array at the specified address
        RAM[write_addr] <= write_data;
    end
end

// Always block for read operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear the read_data register on reset
        read_data <= 6'b000000;
    end else if (read_en) begin
        // Read data from the RAM array at the specified address
        read_data <= RAM[read_addr];
    end else begin
        // Clear the read_data register if read enable is inactive
        read_data <= 6'b000000;
    end
end

endmodule