module LIFObuffer #(
    parameter BUFFER_SIZE = 4,
    parameter DATA_WIDTH = 4
) (
    input [DATA_WIDTH-1:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [DATA_WIDTH-1:0] dataOut
);

reg [DATA_WIDTH-1:0] ram [0:BUFFER_SIZE-1]; // RAM for data storage
reg [1:0] shift_reg; // Shift register for stack pointer

always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        shift_reg <= 2'b00; // Initialize shift register (stack pointer) to 0
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            ram[i] <= {DATA_WIDTH{1'b0}}; // Initialize RAM to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin // Enable signal is high
        if (!RW && shift_reg < BUFFER_SIZE - 1 && !FULL) begin // Push operation
            ram[shift_reg] <= dataIn; // Store data in RAM
            shift_reg <= shift_reg + 1; // Increment stack pointer
        end else if (RW && shift_reg > 0 && !EMPTY) begin // Pop operation
            dataOut <= ram[shift_reg - 1]; // Retrieve data from RAM
            ram[shift_reg - 1] <= {DATA_WIDTH{1'b0}}; // Clear popped data
            shift_reg <= shift_reg - 1; // Decrement stack pointer
        end
    end
end

assign EMPTY = (shift_reg == 0); // Buffer is empty when shift register is 0
assign FULL = (shift_reg == BUFFER_SIZE); // Buffer is full when shift register is equal to BUFFER_SIZE

endmodule