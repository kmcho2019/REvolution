module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

// Declare the stack memory array
reg [3:0] stack_mem[0:3];

// Declare the stack pointer
reg [1:0] SP;

// Initialize the stack pointer and flags
initial begin
    SP = 4'b100; // Initialize SP to 4, indicating an empty buffer
    EMPTY = 1'b1;
    FULL = 1'b0;
end

// Clock process
always @(posedge Clk) begin
    // Check if reset is high
    if (Rst) begin
        // Clear the stack and reset the stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 4;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end
    // Check if enable is high
    else if (EN) begin
        // Check if RW is low (write operation)
        if (!RW) begin
            // Check if the buffer is not full
            if (!FULL) begin
                // Push data onto the stack
                stack_mem[SP - 1] <= dataIn;
                // Decrement the stack pointer
                SP <= SP - 1;
                // Update flags
                if (SP == 1) begin
                    FULL <= 1'b1;
                end
                EMPTY <= 1'b0;
            end
        end
        // Check if RW is high (read operation)
        else begin
            // Check if the buffer is not empty
            if (!EMPTY) begin
                // Pop data from the stack
                dataOut <= stack_mem[SP];
                // Clear the corresponding stack memory
                stack_mem[SP] <= 4'b0;
                // Increment the stack pointer
                SP <= SP + 1;
                // Update flags
                if (SP == 4) begin
                    EMPTY <= 1'b1;
                end
                FULL <= 1'b0;
            end
        end
    end
end

endmodule