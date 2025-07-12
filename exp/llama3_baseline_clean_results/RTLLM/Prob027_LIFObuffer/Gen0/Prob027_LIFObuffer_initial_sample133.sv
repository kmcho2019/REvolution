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

reg [3:0] stack_mem [0:3]; // 4-entry deep, 4-bit wide stack memory
reg [1:0] SP; // 2-bit stack pointer (0-3)
reg EMPTY_reg, FULL_reg; // registers for EMPTY and FULL flags

// Initialize stack pointer and flags
initial begin
    SP = 4'b100; // Initialize SP to 4, indicating an empty buffer
    EMPTY_reg = 1'b1; // Buffer is empty initially
    FULL_reg = 1'b0; // Buffer is not full initially
end

// Update stack pointer and flags on rising edge of clock
always @(posedge Clk) begin
    if (EN) begin
        if (Rst) begin
            // Reset stack and stack pointer
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'b0000;
            end
            SP <= 2'b100; // Reset SP to 4, indicating an empty buffer
            EMPTY_reg <= 1'b1; // Buffer is empty after reset
            FULL_reg <= 1'b0; // Buffer is not full after reset
        end else begin
            // Check for full or empty buffer
            if (RW == 1'b0 && FULL_reg == 1'b0) begin
                // Write (push) operation: data from dataIn is pushed onto the stack
                stack_mem[SP] <= dataIn;
                SP <= SP - 1'b1; // Decrement stack pointer
                EMPTY_reg <= 1'b0; // Buffer is not empty after push
                if (SP == 2'b000) begin
                    FULL_reg <= 1'b1; // Buffer is full after push
                end else begin
                    FULL_reg <= 1'b0; // Buffer is not full after push
                end
            end else if (RW == 1'b1 && EMPTY_reg == 1'b0) begin
                // Read (pop) operation: data is popped from the stack into dataOut
                dataOut <= stack_mem[SP + 1'b1];
                stack_mem[SP + 1'b1] <= 4'b0000; // Clear popped memory location
                SP <= SP + 1'b1; // Increment stack pointer
                FULL_reg <= 1'b0; // Buffer is not full after pop
                if (SP == 2'b100) begin
                    EMPTY_reg <= 1'b1; // Buffer is empty after pop
                end else begin
                    EMPTY_reg <= 1'b0; // Buffer is not empty after pop
                end
            end
        end
    end
end

// Assign output flags
assign EMPTY = EMPTY_reg;
assign FULL = FULL_reg;

endmodule