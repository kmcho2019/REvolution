module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output [5:0] read_data
);

// Define the parameters
parameter WIDTH = 6;
parameter DEPTH = 8;

// Define the RAM array
reg [WIDTH-1:0] RAM [DEPTH-1:0];

// Initialize the RAM array with zeros
integer i;
initial begin
    for (i = 0; i < DEPTH; i++) begin
        RAM[i] = 6'd0;
    end
end

// Write operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the RAM array
        for (i = 0; i < DEPTH; i++) begin
            RAM[i] <= 6'd0;
        end
    end else if (write_en) begin
        // Write data to the RAM array
        RAM[write_addr] <= write_data;
    end
end

// Read operation
reg [WIDTH-1:0] read_data_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the read_data register
        read_data_reg <= 6'd0;
    end else if (read_en) begin
        // Read data from the RAM array
        read_data_reg <= RAM[read_addr];
    end else begin
        // Clear the read_data register if read enable is not active
        read_data_reg <= 6'd0;
    end
end

// Assign the read_data register to the output port
assign read_data = read_data_reg;

endmodule