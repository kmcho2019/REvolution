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

reg [3:0] stack_mem [0:3]; // 4-entry stack memory
reg [1:0] SP; // Stack pointer (0-3)

always @ (posedge Clk) begin
    if (EN) begin
        if (Rst) begin // Reset
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'b0; // Initialize all memory locations to 0
            end
            SP <= 4; // Set stack pointer to 4 (empty buffer)
            EMPTY <= 1'b1; // Set EMPTY flag high
            FULL <= 1'b0; // Set FULL flag low
        end else begin
            if (~RW && ~FULL) begin // Write operation (push data onto stack)
                stack_mem[SP - 1] <= dataIn; // Push data onto stack
                if (SP == 1) begin // Check if buffer will be full after push
                    FULL <= 1'b1; // Set FULL flag high
                end
                SP <= SP - 1; // Decrement stack pointer
                if (SP == 0) begin // Check if buffer is empty after push
                    EMPTY <= 1'b0; // Set EMPTY flag low
                end
            end else if (RW && ~EMPTY) begin // Read operation (pop data from stack)
                dataOut <= stack_mem[SP]; // Pop data from stack into dataOut
                stack_mem[SP] <= 4'b0; // Clear popped data from stack
                if (SP == 4) begin // Check if buffer will be empty after pop
                    EMPTY <= 1'b1; // Set EMPTY flag high
                end
                SP <= SP + 1; // Increment stack pointer
                if (SP == 1) begin // Check if buffer is full after pop
                    FULL <= 1'b0; // Set FULL flag low
                end
            end
        end
    end
end

endmodule