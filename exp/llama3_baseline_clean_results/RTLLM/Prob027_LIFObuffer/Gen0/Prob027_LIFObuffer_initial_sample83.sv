module LIFObuffer(
    input [3:0] dataIn,  // 4-bit input data to be pushed onto the buffer
    input RW,          // Read/Write control signal (1 for read, 0 for write)
    input EN,          // Enable signal to activate buffer operations
    input Rst,         // Active high reset signal to initialize the buffer
    input Clk,         // Clock signal for synchronous operations
    output EMPTY,      // Flag indicating whether the buffer is empty
    output FULL,       // Flag indicating whether the buffer is full
    output [3:0] dataOut  // 4-bit output data retrieved from the buffer
);

reg [3:0] stack_mem[0:3];  // stack memory array
reg [1:0] SP;            // stack pointer

always @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack and stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 4;
    end else if (EN) begin
        if (RW == 0 && SP != 0) begin
            // Push data onto the stack (write operation)
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW == 1 && SP != 4) begin
            // Pop data from the stack (read operation)
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

// Update EMPTY and FULL flags
assign EMPTY = (SP == 4);
assign FULL = (SP == 0);

// Assign dataOut to prevent latch
always @(posedge Clk) begin
    if (Rst) begin
        dataOut <= 4'b0;
    end else if (EN && RW == 1 && SP != 4) begin
        dataOut <= stack_mem[SP];
    end
end

endmodule