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

parameter WIDTH = 6;
parameter DEPTH = 8;

reg [WIDTH-1:0] RAM [DEPTH-1:0];
reg [WIDTH-1:0] read_data_reg;

// Initialize RAM array
initial begin
    for (int i = 0; i < DEPTH; i++) begin
        RAM[i] = {WIDTH{1'b0}};
    end
end

// Write operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all memory locations
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= {WIDTH{1'b0}};
        end
    end else if (write_en) begin
        // Write data to the specified address
        RAM[write_addr] <= write_data;
    end
end

// Read operation
always @(posedge clk) begin
    if (read_en) begin
        // Assign data from the RAM array to the output register
        read_data_reg <= RAM[read_addr];
    end else begin
        // Clear the output register if read is not enabled
        read_data_reg <= {WIDTH{1'b0}};
    end
end

// Combinational logic for read_data output
assign read_data = read_data_reg;

endmodule