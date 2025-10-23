module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
) (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [WIDTH-1:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output reg [WIDTH-1:0] read_data
);

    reg [WIDTH-1:0] RAM [DEPTH-1:0];

    // Initialize all memory locations to 0
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i++) begin
            RAM[i] = 6'b000000;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all memory locations to 0
            for (i = 0; i < DEPTH; i++) begin
                RAM[i] <= 6'b000000;
            end
        end else if (write_en) begin
            // Write data to the RAM array at the specified address
            RAM[write_addr] <= write_data;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset the read_data register to 0
            read_data <= 6'b000000;
        end else if (read_en) begin
            // Assign the data at the specified address to the read_data register
            read_data <= RAM[read_addr];
        end else begin
            // Clear the read_data register to 0 if read enable is not active
            read_data <= 6'b000000;
        end
    end

endmodule