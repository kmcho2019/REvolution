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

// Define parameters for width and depth
parameter WIDTH = 6;
parameter DEPTH = 8;

// Define the RAM array
reg [WIDTH-1:0] RAM [DEPTH-1:0];

// Initialize the RAM array
integer i;
initial begin
    for (i = 0; i < DEPTH; i++) begin
        RAM[i] = 6'b000000;
    end
end

// Write operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the RAM array
        for (i = 0; i < DEPTH; i++) begin
            RAM[i] <= 6'b000000;
        end
    end else if (write_en) begin
        // Write data to the RAM array
        RAM[write_addr] <= write_data;
    end
end

// Read operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the read_data register
        read_data <= 6'b000000;
    end else if (read_en) begin
        // Read data from the RAM array
        read_data <= RAM[read_addr];
    end else begin
        // Clear the read_data register if read_en is not active
        read_data <= 6'b000000;
    end
end

endmodule