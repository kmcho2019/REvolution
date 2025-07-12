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

reg [3:0] stack_mem [0:3]; // 4-entry stack memory array
reg [1:0] SP; // Stack pointer (0-3)

// Initialize outputs
initial begin
    EMPTY = 1'b1; // Buffer is empty initially
    FULL = 1'b0; // Buffer is not full initially
    dataOut = 4'b0; // Initialize dataOut to 0
    SP = 4; // Initialize stack pointer to 4 (empty buffer)
end

// Clock logic
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        SP <= 4; // Initialize stack pointer to 4 (empty buffer)
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0; // Initialize stack memory to 0
        end
        EMPTY <= 1'b1; // Buffer is empty
        FULL <= 1'b0; // Buffer is not full
        dataOut <= 4'b0; // Initialize dataOut
    end else if (EN) begin // Enable signal is high
        if (~RW) begin // Write operation (RW is low)
            if (SP > 0) begin // Buffer is not full
                stack_mem[SP-1] <= dataIn; // Push data onto stack
                SP <= SP - 1; // Decrement stack pointer
            end
        end else begin // Read operation (RW is high)
            if (SP < 4) begin // Buffer is not empty
                dataOut <= stack_mem[SP]; // Pop data from stack
                stack_mem[SP] <= 4'b0; // Clear popped data
                SP <= SP + 1; // Increment stack pointer
            end
        end
    end
    
    // Update EMPTY and FULL flags
    if (SP == 4) begin
        EMPTY <= 1'b1; // Buffer is empty
        FULL <= 1'b0; // Buffer is not full
    end else if (SP == 0) begin
        EMPTY <= 1'b0; // Buffer is not empty
        FULL <= 1'b1; // Buffer is full
    end else begin
        EMPTY <= 1'b0; // Buffer is not empty
        FULL <= 1'b0; // Buffer is not full
    end
end

endmodule