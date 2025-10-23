module LIFObuffer (
    input [3:0] dataIn,  // 4-bit input data
    input RW,          // Read/Write control signal (1 for read, 0 for write)
    input EN,          // Enable signal to activate buffer operations
    input Rst,         // Active high reset signal to initialize the buffer
    input Clk,         // Clock signal for synchronous operations
    output reg EMPTY,  // Flag indicating whether the buffer is empty
    output reg FULL,   // Flag indicating whether the buffer is full
    output reg [3:0] dataOut  // 4-bit output data retrieved from the buffer
);

// Define the stack memory array
reg [3:0] stack_mem [0:3];

// Define the stack pointer
reg [1:0] SP;

// Initialize the stack pointer and flags
initial begin
    SP = 4;
    EMPTY = 1'b1;
    FULL = 1'b0;
end

// Update the stack pointer and flags on the rising edge of the clock
always @(posedge Clk) begin
    if (EN) begin
        if (Rst) begin
            // Reset the stack and flags
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'b0;
            end
            SP <= 4;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
        end else begin
            // Check if the buffer is full or empty and process data accordingly
            if (RW == 1'b0 && FULL == 1'b0) begin
                // Push data onto the stack (write operation)
                stack_mem[SP - 1] <= dataIn;
                SP <= SP - 1;
                if (SP == 0) begin
                    FULL <= 1'b1;
                end
                EMPTY <= 1'b0;
            end else if (RW == 1'b1 && EMPTY == 1'b0) begin
                // Pop data from the stack (read operation)
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= 4'b0;
                SP <= SP + 1;
                if (SP == 4) begin
                    EMPTY <= 1'b1;
                end
                FULL <= 1'b0;
            end
        end
    end
end

// Update the EMPTY and FULL flags based on the stack pointer status
always @(*) begin
    if (SP == 4) begin
        EMPTY = 1'b1;
    end else begin
        EMPTY = 1'b0;
    end
    if (SP == 0) begin
        FULL = 1'b1;
    end else begin
        FULL = 1'b0;
    end
end

endmodule