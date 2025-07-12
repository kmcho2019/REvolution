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

// Define the stack memory array
reg [3:0] stack_mem [3:0];

// Define the stack pointer
reg [1:0] SP;

// Initialize the stack pointer and flags
initial begin
    SP = 4'd4;
    EMPTY = 1'b1;
    FULL = 1'b0;
end

// Define the always block for clock edge operations
always @(posedge Clk) begin
    // Reset operation
    if (Rst) begin
        // Clear the stack memory
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        // Set the stack pointer to indicate an empty buffer
        SP <= 4'd4;
        // Update flags
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end
    // Enable signal is high
    else if (EN) begin
        // Write operation (RW is low)
        if (~RW) begin
            // Check if the buffer is not full
            if (SP > 4'd0) begin
                // Push data onto the stack
                stack_mem[SP - 1] <= dataIn;
                // Decrement the stack pointer
                SP <= SP - 1;
                // Update flags
                EMPTY <= (SP == 4'd4) ? 1'b1 : 1'b0;
                FULL <= (SP == 4'd0) ? 1'b1 : 1'b0;
            end
        end
        // Read operation (RW is high)
        else if (RW) begin
            // Check if the buffer is not empty
            if (SP < 4'd4) begin
                // Pop data from the stack
                dataOut <= stack_mem[SP];
                // Clear the corresponding stack memory
                stack_mem[SP] <= 4'd0;
                // Increment the stack pointer
                SP <= SP + 1;
                // Update flags
                EMPTY <= (SP == 4'd4) ? 1'b1 : 1'b0;
                FULL <= (SP == 4'd0) ? 1'b1 : 1'b0;
            end
        end
    end
end

// Default assignment for dataOut (to avoid latch inference)
assign dataOut = (SP < 4'd4) ? stack_mem[SP] : 4'd0;

// Flag assignments
assign EMPTY = (SP == 4'd4) ? 1'b1 : 1'b0;
assign FULL = (SP == 4'd0) ? 1'b1 : 1'b0;

endmodule