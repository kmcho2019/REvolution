module LIFObuffer(
    input [3:0] dataIn, // 4-bit input data to be pushed onto the buffer
    input RW,           // Read/Write control signal (1 for read, 0 for write)
    input EN,           // Enable signal to activate buffer operations
    input Rst,          // Active high reset signal to initialize the buffer
    input Clk,          // Clock signal for synchronous operations
    output EMPTY,       // Flag indicating whether the buffer is empty
    output FULL,        // Flag indicating whether the buffer is full
    output [3:0] dataOut // 4-bit output data retrieved from the buffer
);

reg [3:0] stack_mem[0:3]; // stack memory array
reg [1:0] SP;             // stack pointer

assign EMPTY = (SP == 4'd4); // buffer is empty when SP is 4
assign FULL = (SP == 4'd0); // buffer is full when SP is 0

always @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack and the stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0; // initialize stack memory to 0
        end
        SP <= 4'd4; // initialize stack pointer to 4 (empty buffer)
    end else if (EN) begin
        if (~RW && ~FULL) begin
            // Push data onto the stack
            stack_mem[SP - 1] <= dataIn; // store data in the stack
            SP <= SP - 1; // decrement the stack pointer
        end else if (RW && ~EMPTY) begin
            // Pop data from the stack
            dataOut <= stack_mem[SP]; // assign popped data to dataOut
            stack_mem[SP] <= 4'd0; // clear the popped data from the stack
            SP <= SP + 1; // increment the stack pointer
        end
    end
end

endmodule