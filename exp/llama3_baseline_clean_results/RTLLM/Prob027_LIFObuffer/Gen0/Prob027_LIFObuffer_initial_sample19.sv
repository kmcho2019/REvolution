module LIFObuffer(
    input  logic        Clk,      // Clock signal
    input  logic        Rst,      // Active high reset signal
    input  logic        EN,       // Enable signal
    input  logic        RW,       // Read/Write control signal (1 for read, 0 for write)
    input  logic [3:0]  dataIn,   // 4-bit input data to be pushed onto the buffer
    output logic [3:0]  dataOut,  // 4-bit output data retrieved from the buffer
    output logic        EMPTY,    // Flag indicating whether the buffer is empty
    output logic        FULL      // Flag indicating whether the buffer is full
);

// Stack memory declaration
logic [3:0] stack_mem [3:0];

// Stack pointer declaration
logic [1:0] SP;

// Reset logic
always_ff @(posedge Clk) begin
    if (Rst) begin
        // Clear stack and initialize stack pointer on reset
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 2'd4;
    end
    else if (EN) begin
        // Handle write operation
        if (~RW && SP!= 2'd0) begin
            // Push data onto the stack
            stack_mem[SP - 1] <= dataIn;
            // Decrement stack pointer
            SP <= SP - 1;
        end
        // Handle read operation
        else if (RW && SP!= 2'd4) begin
            // Pop data from the stack
            dataOut <= stack_mem[SP];
            // Clear popped data from stack
            stack_mem[SP] <= 4'd0;
            // Increment stack pointer
            SP <= SP + 1;
        end
    end
end

// Update EMPTY and FULL flags
always_comb begin
    EMPTY = (SP == 2'd4);
    FULL  = (SP == 2'd0);
end

endmodule