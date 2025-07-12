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

reg [3:0] stack_mem[3:0]; // 4x4-bit stack memory
reg [1:0] SP; // 2-bit stack pointer

always @(posedge Clk) begin
    if (Rst) begin
        // Reset: Clear stack memory, stack pointer, and flags
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 2'd4; // Initialize stack pointer to indicate an empty buffer
        EMPTY <= 1'b1;
        FULL <= 1'b0;
        dataOut <= 4'd0;
    end else if (EN) begin
        if (~RW && !FULL) begin
            // Write operation: Push data onto the stack
            stack_mem[SP-1] <= dataIn;
            if (SP == 2'd1) begin
                FULL <= 1'b1;
            end
            SP <= SP - 1;
            EMPTY <= 1'b0;
        end else if (RW && !EMPTY) begin
            // Read operation: Pop data from the stack
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'd0;
            if (SP == 2'd0) begin
                EMPTY <= 1'b1;
            end
            FULL <= 1'b0;
            SP <= SP + 1;
        end
    end
end

assign EMPTY = (SP == 2'd4);
assign FULL = (SP == 2'd0);

endmodule