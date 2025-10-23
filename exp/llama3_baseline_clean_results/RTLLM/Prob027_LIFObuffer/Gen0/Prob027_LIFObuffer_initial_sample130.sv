module LIFObuffer(
    input       [3:0] dataIn,  // 4-bit input data
    input             RW,      // Read/Write control signal
    input             EN,      // Enable signal
    input             Rst,     // Active high reset signal
    input             Clk,     // Clock signal
    output      [3:0] dataOut, // 4-bit output data
    output            EMPTY,   // Flag indicating whether the buffer is empty
    output            FULL     // Flag indicating whether the buffer is full
);

reg [3:0] stack_mem [3:0]; // Stack memory array
reg [1:0] SP;             // Stack pointer

always @(posedge Clk) begin
    if (Rst) begin // Reset buffer
        SP <= 4'd4; // Set stack pointer to indicate an empty buffer
        for (int i = 0; i < 4; i++) begin // Initialize stack memory
            stack_mem[i] <= 4'd0;
        end
    end else if (EN) begin // Enable buffer operations
        if (RW == 1'b0 && SP!= 4'd0) begin // Write operation and buffer is not full
            stack_mem[SP - 1] <= dataIn; // Push data onto the stack
            SP <= SP - 1; // Decrement stack pointer
        end else if (RW == 1'b1 && SP!= 4'd4) begin // Read operation and buffer is not empty
            dataOut <= stack_mem[SP]; // Pop data from the stack
            stack_mem[SP] <= 4'd0; // Clear the corresponding stack memory
            SP <= SP + 1; // Increment stack pointer
        end
    end
end

assign EMPTY = (SP == 4'd4)? 1'b1 : 1'b0; // Flag indicating whether the buffer is empty
assign FULL = (SP == 4'd0)? 1'b1 : 1'b0; // Flag indicating whether the buffer is full

endmodule