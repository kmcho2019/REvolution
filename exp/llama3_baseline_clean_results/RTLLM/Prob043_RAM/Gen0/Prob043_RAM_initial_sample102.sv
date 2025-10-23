module RAM (
    input             clk,
    input             rst_n,
    input             write_en,
    input  [2:0]      write_addr,
    input  [5:0]      write_data,
    input             read_en,
    input  [2:0]      read_addr,
    output reg [5:0]  read_data
);

    localparam WIDTH = 6;
    localparam DEPTH = 8;

    reg [5:0] RAM [7:0];

    integer i;

    // Initialize all memory locations to 0 on reset
    initial begin
        for (i = 0; i < DEPTH; i++) begin
            RAM[i] = 6'b000000;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all memory locations to 0 on reset
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
            // Clear the read_data register on reset
            read_data <= 6'b000000;
        end else if (read_en) begin
            // Assign the data at the specified address in the RAM array to the read_data register
            read_data <= RAM[read_addr];
        end else begin
            // Clear the read_data register if the read enable signal is not active
            read_data <= 6'b000000;
        end
    end

endmodule