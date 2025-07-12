module LIFObuffer(
    input [3:0] dataIn,  // 4-bit input data to be pushed onto the buffer
    input RW,            // Read/Write control signal (1 for read, 0 for write)
    input EN,            // Enable signal to activate buffer operations
    input Rst,           // Active high reset signal to initialize the buffer
    input Clk,           // Clock signal for synchronous operations
    output reg EMPTY,    // Flag indicating whether the buffer is empty
    output reg FULL,     // Flag indicating whether the buffer is full
    output reg [3:0] dataOut  // 4-bit output data retrieved from the buffer
);

reg [3:0] stack_mem[3:0];  // Stack memory array
reg [1:0] SP;             // Stack pointer

always @(posedge Clk) begin
    if (Rst) begin  // Reset condition
        stack_mem[0] <= 4'b0;
        stack_mem[1] <= 4'b0;
        stack_mem[2] <= 4'b0;
        stack_mem[3] <= 4'b0;
        SP <= 2'b11;  // Initialize stack pointer to 3 (empty buffer)
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end
    else if (EN) begin  // Enable condition
        if (~RW && (SP != 2'b00)) begin  // Write operation and buffer is not full
            stack_mem[SP] <= dataIn;
            SP <= SP - 1;
            FULL <= (SP == 2'b00) ? 1'b1 : 1'b0;
            EMPTY <= 1'b0;
        end
        else if (RW && (SP != 2'b11)) begin  // Read operation and buffer is not empty
            dataOut <= stack_mem[SP + 1];
            stack_mem[SP + 1] <= 4'b0;
            SP <= SP + 1;
            FULL <= 1'b0;
            EMPTY <= (SP == 2'b11) ? 1'b1 : 1'b0;
        end
        else begin  // No operation
            FULL <= (SP == 2'b00) ? 1'b1 : 1'b0;
            EMPTY <= (SP == 2'b11) ? 1'b1 : 1'b0;
        end
    end
    else begin  // Disable condition
        FULL <= (SP == 2'b00) ? 1'b1 : 1'b0;
        EMPTY <= (SP == 2'b11) ? 1'b1 : 1'b0;
    end
end

endmodule