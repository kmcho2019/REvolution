module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output EMPTY,
    output FULL,
    output [3:0] dataOut
);

reg [3:0] stack_mem [0:3]; // Stack memory array
reg [1:0] SP; // Stack pointer
reg EMPTY_reg, FULL_reg; // Registers for EMPTY and FULL flags
reg [3:0] dataOut_reg; // Register for output data

// Initialize stack pointer and flags
initial begin
    SP = 4'b100; // Initialize stack pointer to 4, indicating an empty buffer
    EMPTY_reg = 1'b1; // Initialize EMPTY flag to 1 (high)
    FULL_reg = 1'b0; // Initialize FULL flag to 0 (low)
end

// Synchronous operations on the rising edge of the clock
always @(posedge Clk) begin
    if (EN) begin
        if (Rst) begin
            // Reset the stack, stack pointer, and flags
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'b0; // Clear stack memory
            end
            SP <= 4; // Set stack pointer to 4, indicating an empty buffer
            EMPTY_reg <= 1'b1; // Set EMPTY flag to 1 (high)
            FULL_reg <= 1'b0; // Set FULL flag to 0 (low)
        end else begin
            // Check if the buffer is full or empty and process data accordingly
            if (RW == 1'b0 && FULL_reg == 1'b0) begin
                // Push data onto the stack (write operation)
                stack_mem[SP - 1] <= dataIn; // Store data in stack memory
                SP <= SP - 1; // Decrement stack pointer
            end else if (RW == 1'b1 && EMPTY_reg == 1'b0) begin
                // Pop data from the stack (read operation)
                dataOut_reg <= stack_mem[SP]; // Retrieve data from stack memory
                stack_mem[SP] <= 4'b0; // Clear stack memory
                SP <= SP + 1; // Increment stack pointer
            end
        end
    end
end

// Update EMPTY and FULL flags based on the stack pointer's status
always @(SP) begin
    if (SP == 4) begin
        EMPTY_reg <= 1'b1; // Set EMPTY flag to 1 (high) if the buffer is empty
        FULL_reg <= 1'b0; // Set FULL flag to 0 (low) if the buffer is not full
    end else if (SP == 0) begin
        EMPTY_reg <= 1'b0; // Set EMPTY flag to 0 (low) if the buffer is not empty
        FULL_reg <= 1'b1; // Set FULL flag to 1 (high) if the buffer is full
    end else begin
        EMPTY_reg <= 1'b0; // Set EMPTY flag to 0 (low) if the buffer is not empty
        FULL_reg <= 1'b0; // Set FULL flag to 0 (low) if the buffer is not full
    end
end

// Assign output signals
assign EMPTY = EMPTY_reg;
assign FULL = FULL_reg;
assign dataOut = dataOut_reg;

endmodule