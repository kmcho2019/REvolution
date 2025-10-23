module LIFObuffer(
    input [3:0] dataIn,  // 4-bit input data to be pushed onto the buffer
    input RW,            // Read/Write control signal (1 for read, 0 for write)
    input EN,            // Enable signal to activate buffer operations
    input Rst,           // Active high reset signal to initialize the buffer
    input Clk,           // Clock signal for synchronous operations
    output reg EMPTY,    // Flag indicating whether the buffer is empty
    output reg FULL,     // Flag indicating whether the buffer is full
    output reg [3:0] dataOut  // 4-bit output data retrieved from the buffer
);

reg [3:0] stack_mem [3:0];  // Stack memory array
reg [1:0] SP;              // Stack pointer

always @ (posedge Clk) begin
    if (Rst) begin
        // Initialize stack memory and stack pointer on reset
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 2'd4;  // Set stack pointer to 4 (indicating an empty buffer)
        EMPTY <= 1'b1;  // Set EMPTY flag to high
        FULL <= 1'b0;   // Set FULL flag to low
    end else if (EN) begin
        // Check if buffer is full or empty and process data accordingly
        if (~RW && (SP!= 2'd0)) begin
            // Push data onto the stack if buffer is not full
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && (SP!= 2'd4)) begin
            // Pop data from the stack if buffer is not empty
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'd0;
            SP <= SP + 1;
        end
        // Update EMPTY and FULL flags based on stack pointer status
        EMPTY <= (SP == 2'd4)? 1'b1 : 1'b0;
        FULL <= (SP == 2'd0)? 1'b1 : 1'b0;
    end
end

endmodule