module LIFObuffer(
    input  logic        Clk,        // Clock signal
    input  logic        Rst,        // Active high reset signal
    input  logic        EN,         // Enable signal
    input  logic        RW,         // Read/Write control signal
    input  logic [3:0]  dataIn,     // 4-bit input data
    output logic        EMPTY,      // Flag indicating whether the buffer is empty
    output logic        FULL,       // Flag indicating whether the buffer is full
    output logic [3:0]  dataOut     // 4-bit output data
);

// Stack memory array to store the data
logic [3:0] stack_mem [3:0];

// Stack pointer to track the current position in the stack
logic [1:0] SP;

always_ff @(posedge Clk) begin
    if (Rst) begin
        // Initialize the stack memory and stack pointer on reset
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 2'd4;
    end else if (EN) begin
        if (RW == 1'b0 && SP != 2'd0) begin
            // Push data onto the stack for write operation
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW == 1'b1 && SP != 2'd4) begin
            // Pop data from the stack for read operation
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'd0;
            SP <= SP + 1;
        end
    end
end

// Update the EMPTY and FULL flags
assign EMPTY = (SP == 2'd4);
assign FULL = (SP == 2'd0);

endmodule