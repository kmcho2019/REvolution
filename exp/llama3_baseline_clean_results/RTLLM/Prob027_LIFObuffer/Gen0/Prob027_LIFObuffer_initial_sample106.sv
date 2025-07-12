module LIFObuffer(
    input         Clk,         // Clock signal
    input         Rst,         // Active high reset signal
    input         EN,          // Enable signal
    input         RW,          // Read/Write control signal (1 for read, 0 for write)
    input  [3:0]  dataIn,      // 4-bit input data to be pushed onto the buffer
    output [3:0]  dataOut,     // 4-bit output data retrieved from the buffer
    output        EMPTY,       // Flag indicating whether the buffer is empty
    output        FULL         // Flag indicating whether the buffer is full
);

reg [3:0] stack_mem [0:3];  // Stack memory array
reg [1:0] SP;             // Stack pointer

always @(posedge Clk) begin
    if (Rst) begin
        // Reset state
        SP <= 4;
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
    end else if (EN) begin
        // Check for write operation
        if (~RW && SP > 0) begin
            // Push data onto the stack
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end
        // Check for read operation
        else if (RW && SP < 4) begin
            // Pop data from the stack
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

// Update EMPTY and FULL flags
assign EMPTY = (SP == 4);
assign FULL  = (SP == 0);

endmodule