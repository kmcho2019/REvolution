module LIFObuffer(
    input [3:0] dataIn,  // 4-bit input data
    input RW,          // Read/Write control signal
    input EN,          // Enable signal
    input Rst,         // Active high reset signal
    input Clk,         // Clock signal
    output EMPTY,      // Flag indicating whether the buffer is empty
    output FULL,       // Flag indicating whether the buffer is full
    output [3:0] dataOut  // 4-bit output data
);

reg [3:0] stack_mem [0:3];  // Stack memory array
reg [1:0] SP;             // Stack pointer
reg [3:0] temp_dataOut;   // Temporary output data

always @(posedge Clk) begin
    if (Rst) begin  // Active high reset
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;  // Initialize stack memory to 0
        end
        SP <= 4;  // Set stack pointer to 4 (indicating an empty buffer)
    end else if (EN) begin  // Enable signal is high
        if (RW == 0 && SP > 0) begin  // Write operation and buffer is not full
            stack_mem[SP - 1] <= dataIn;  // Push data onto the stack
            SP <= SP - 1;  // Decrement stack pointer
        end else if (RW == 1 && SP < 4) begin  // Read operation and buffer is not empty
            temp_dataOut <= stack_mem[SP];  // Pop data from the stack
            stack_mem[SP] <= 4'b0;  // Clear the corresponding stack memory
            SP <= SP + 1;  // Increment stack pointer
        end
    end
end

assign EMPTY = (SP == 4);  // Buffer is empty when stack pointer is 4
assign FULL = (SP == 0);  // Buffer is full when stack pointer is 0
assign dataOut = temp_dataOut;  // Assign temporary output data to output

endmodule