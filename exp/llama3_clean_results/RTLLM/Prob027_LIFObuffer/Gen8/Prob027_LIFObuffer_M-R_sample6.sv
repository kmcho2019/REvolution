module LIFObuffer(
    input [3:0] dataIn,  // 4-bit input data to be pushed onto the buffer
    input RW,            // Read/Write control signal (1 for read, 0 for write)
    input EN,            // Enable signal to activate buffer operations
    input Rst,           // Active high reset signal to initialize the buffer
    input Clk,           // Clock signal for synchronous operations
    output reg EMPTY,    // Flag indicating whether the buffer is empty
    output reg FULL,     // Flag indicating whether the buffer is full
    output reg [3:0] dataOut // 4-bit output data retrieved from the buffer
);

// Stack memory
reg [3:0] stack_mem[3:0];

// Stack pointer
reg [1:0] SP;

// Combinational logic for EMPTY and FULL flags
assign EMPTY = (SP == 2'd3);
assign FULL = (SP == 2'd0);

// Sequential logic
always @(posedge Clk) begin
    if (Rst) begin
        // Reset: Clear stack, set SP to 3 (indicating empty buffer), and initialize memory
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 2'd3; // Initialize SP to indicate an empty buffer
        dataOut <= 4'd0;
    end else if (EN) begin
        if (~RW) begin
            // Write operation: Push data onto the stack
            if (SP > 2'd0) begin
                stack_mem[SP - 1] <= dataIn;
                SP <= SP - 1; // Decrement SP
            end
        end else if (RW) begin
            // Read operation: Pop data from the stack
            if (SP < 2'd3) begin
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= 4'd0;
                SP <= SP + 1; // Increment SP
            end
        end
    end
end

endmodule