module LIFObuffer (
    input           Clk,        // Clock signal
    input           Rst,        // Active high reset signal
    input           EN,         // Enable signal
    input           RW,         // Read/Write control signal (1 for read, 0 for write)
    input   [3:0]   dataIn,     // 4-bit input data to be pushed onto the buffer
    output          EMPTY,      // Flag indicating whether the buffer is empty
    output          FULL,       // Flag indicating whether the buffer is full
    output  [3:0]   dataOut     // 4-bit output data retrieved from the buffer
);

// Stack memory array
reg [3:0] stack_mem [3:0];

// Stack pointer
reg [1:0] SP;

// Initialize stack pointer to 4 (indicating an empty buffer)
integer i;

always @(posedge Clk) begin
    if (Rst) begin
        // Clear the stack and initialize the stack pointer to 4
        for (i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 2'd4;
    end else if (EN) begin
        // Check if the buffer is full
        if (RW == 0 && SP!= 0) begin
            // Push data onto the stack
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW == 1 && SP!= 4) begin
            // Pop data from the stack
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'd0;
            SP <= SP + 1;
        end
    end
end

// Update EMPTY and FULL flags
assign EMPTY = (SP == 4);
assign FULL = (SP == 0);

endmodule