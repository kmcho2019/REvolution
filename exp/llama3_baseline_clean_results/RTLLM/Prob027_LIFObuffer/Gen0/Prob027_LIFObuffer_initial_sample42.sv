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
reg [1:0] SP; // Stack pointer

always @(posedge Clk) begin
    if (EN) begin
        if (Rst) begin // Active high reset
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'b0; // Initialize stack memory to 0
            end
            SP <= 4'b100; // Initialize stack pointer to 4 (empty buffer)
            EMPTY <= 1'b1; // Buffer is empty
            FULL <= 1'b0; // Buffer is not full
            dataOut <= 4'b0; // Initialize output to 0
        end else begin
            if (RW == 0 && SP != 4'b100) begin // Write operation and buffer is not full
                stack_mem[SP] <= dataIn; // Push data onto stack
                SP <= SP - 1; // Decrement stack pointer
                EMPTY <= 1'b0; // Buffer is not empty
                if (SP == 4'b000) begin // Buffer is full if SP reaches 0
                    FULL <= 1'b1;
                end else begin
                    FULL <= 1'b0;
                end
            end else if (RW == 1 && SP != 4'b100) begin // Read operation and buffer is not empty
                dataOut <= stack_mem[SP + 1]; // Pop data from stack into output
                stack_mem[SP + 1] <= 4'b0; // Clear popped data from stack
                SP <= SP + 1; // Increment stack pointer
                FULL <= 1'b0; // Buffer is not full
                if (SP == 4'b100) begin // Buffer is empty if SP reaches 4
                    EMPTY <= 1'b1;
                end else begin
                    EMPTY <= 1'b0;
                end
            end else begin // Buffer is full or empty, do nothing
                if (SP == 4'b100) begin
                    EMPTY <= 1'b1;
                end else begin
                    EMPTY <= 1'b0;
                end
                if (SP == 4'b000) begin
                    FULL <= 1'b1;
                end else begin
                    FULL <= 1'b0;
                end
            end
        end
    end
end

endmodule