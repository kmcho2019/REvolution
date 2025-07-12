module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output reg [5:0] read_data
);

parameter WIDTH = 6;
parameter DEPTH = 8;

reg [5:0] RAM [7:0];

// Sequential block for write operation and reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset logic to initialize RAM array
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= 6'b0;
        end
        read_data <= 6'b0;
    end else if (write_en) begin
        // Write operation
        RAM[write_addr] <= write_data;
    end
end

// Combinatorial logic for read operation
always @(*) begin
    if (read_en) begin
        // Read operation
        read_data = RAM[read_addr];
    end else begin
        // Clear read_data when read_en is inactive
        read_data = 6'b0;
    end
end

endmodule