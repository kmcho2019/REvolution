module LIFObuffer(
    input  logic        Clk,    // Clock signal
    input  logic        Rst,    // Active high reset signal
    input  logic        EN,     // Enable signal
    input  logic        RW,     // Read/Write control signal (1 for read, 0 for write)
    input  logic [3:0]   dataIn, // 4-bit input data
    output logic        EMPTY,  // Flag indicating whether the buffer is empty
    output logic        FULL,   // Flag indicating whether the buffer is full
    output logic [3:0]  dataOut // 4-bit output data
);

// Define the stack memory array
logic [3:0] stack_mem [3:0];

// Define the stack pointer (SP)
logic [1:0] SP;

always_ff @(posedge Clk) begin
    if (Rst) begin
        // Reset: Clear the stack and set SP to 4 (empty buffer)
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 2'd4;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin
        // Check for buffer status and process data accordingly
        if (!RW && (SP != 2'd0)) begin
            // Write operation: Push data onto the stack and decrement SP
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1'b1;
        end else if (RW && (SP != 2'd4)) begin
            // Read operation: Pop data from the stack, clear the memory location, and increment SP
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'd0;
            SP <= SP + 1'b1;
        end
    end
    // Update EMPTY and FULL flags based on the stack pointer
    EMPTY <= (SP == 2'd4) ? 1'b1 : 1'b0;
    FULL <= (SP == 2'd0) ? 1'b1 : 1'b0;
end

// Default output values
assign dataOut = (SP != 2'd4) ? stack_mem[SP] : 4'd0;

endmodule