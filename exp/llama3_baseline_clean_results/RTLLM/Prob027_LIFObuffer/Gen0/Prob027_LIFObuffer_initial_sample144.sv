module LIFObuffer(
    input [3:0] dataIn, // 4-bit input data to be pushed onto the buffer
    input RW, // Read/Write control signal (1 for read, 0 for write)
    input EN, // Enable signal to activate buffer operations
    input Rst, // Active high reset signal to initialize the buffer
    input Clk, // Clock signal for synchronous operations
    output EMPTY, // Flag indicating whether the buffer is empty
    output FULL, // Flag indicating whether the buffer is full
    output [3:0] dataOut // 4-bit output data retrieved from the buffer
);

reg [3:0] stack_mem [0:3]; // 4-entry stack memory array
reg [1:0] SP; // Stack pointer

always @ (posedge Clk) begin
    if (Rst) begin // Active high reset signal
        // Clear the stack and set the stack pointer to 4 (indicating an empty buffer)
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 2'd4;
    end else if (EN) begin // Enable signal is high
        if (!RW && SP > 0) begin // Write operation (RW is low) and the buffer is not full
            // Push data from dataIn onto the stack and decrement the stack pointer
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && SP < 4) begin // Read operation (RW is high) and the buffer is not empty
            // Pop data from the stack into dataOut, clear the corresponding stack memory, and increment the stack pointer
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

assign EMPTY = (SP == 4); // Flag indicating whether the buffer is empty
assign FULL = (SP == 0); // Flag indicating whether the buffer is full

endmodule