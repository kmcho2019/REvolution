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
parameter NUM_BANKS = 2;

reg [WIDTH-1:0] RAM_BANK [NUM_BANKS-1:0][DEPTH/NUM_BANKS-1:0];
reg [WIDTH-1:0] read_data_reg;

integer i, j;

// Control unit to manage bank allocation and access
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < NUM_BANKS; i++) begin
            for (j = 0; j < DEPTH/NUM_BANKS; j++) begin
                RAM_BANK[i][j] <= 0;
            end
        end
    end else if (write_en) begin
        // Determine the bank for the write operation
        integer bank_index = write_addr / (DEPTH/NUM_BANKS);
        integer bank_addr = write_addr % (DEPTH/NUM_BANKS);
        RAM_BANK[bank_index][bank_addr] <= write_data;
    end
end

// Asynchronous read access
always @(read_en or read_addr) begin
    if (read_en) begin
        // Determine the bank for the read operation
        integer bank_index = read_addr / (DEPTH/NUM_BANKS);
        integer bank_addr = read_addr % (DEPTH/NUM_BANKS);
        read_data_reg = RAM_BANK[bank_index][bank_addr];
    end else begin
        read_data_reg = 0;
    end
end

assign read_data = read_data_reg;

endmodule