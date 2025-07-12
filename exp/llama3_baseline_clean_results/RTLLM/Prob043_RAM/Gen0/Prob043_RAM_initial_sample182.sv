module RAM(
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output [5:0] read_data
);

parameter WIDTH = 6;
parameter DEPTH = 8;

reg [5:0] RAM [7:0];  // Declare the RAM array with the given parameters
reg [5:0] read_data_reg;  // Declare the read_data register

// Write operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // Reset condition
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= 6'b0;  // Initialize all RAM locations to 0 on reset
        end
    end else if (write_en) begin
        RAM[write_addr] <= write_data;  // Write data to the RAM array at the specified address
    end
end

// Read operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // Reset condition
        read_data_reg <= 6'b0;  // Clear the read_data register on reset
    end else if (read_en) begin
        read_data_reg <= RAM[read_addr];  // Assign data from the RAM array to the read_data register
    end else begin
        read_data_reg <= 6'b0;  // Clear the read_data register when read enable is not active
    end
end

assign read_data = read_data_reg;  // Assign the value of the read_data register to the output read_data

endmodule