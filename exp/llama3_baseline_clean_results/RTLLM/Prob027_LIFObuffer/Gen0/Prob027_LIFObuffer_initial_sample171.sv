module LIFObuffer(
    input [3:0] dataIn, // 4-bit input data to be pushed onto the buffer
    input RW, // Read/Write control signal (1 for read, 0 for write)
    input EN, // Enable signal to activate buffer operations
    input Rst, // Active high reset signal to initialize the buffer
    input Clk, // Clock signal for synchronous operations
    output reg EMPTY, // Flag indicating whether the buffer is empty
    output reg FULL, // Flag indicating whether the buffer is full
    output reg [3:0] dataOut // 4-bit output data retrieved from the buffer
);

reg [3:0] stack_mem[0:3]; // Stack memory array to store the data
reg [1:0] SP; // Stack pointer to track the current position in the stack

always @(posedge Clk) begin
    if (EN) begin
        if (Rst) begin
            // Reset the stack and stack pointer
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'd0;
            end
            SP <= 2'd4;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
        end else begin
            if (RW == 0) begin // Write operation
                if (SP != 2'd0) begin // Check if buffer is not full
                    stack_mem[SP - 1] <= dataIn; // Push data onto the stack
                    SP <= SP - 1; // Decrement stack pointer
                end
            end else if (RW == 1) begin // Read operation
                if (SP != 2'd4) begin // Check if buffer is not empty
                    dataOut <= stack_mem[SP]; // Pop data from the stack
                    stack_mem[SP] <= 4'd0; // Clear the corresponding stack memory
                    SP <= SP + 1; // Increment stack pointer
                end
            end
        end
    end

    // Update EMPTY and FULL flags
    if (SP == 2'd4) begin
        EMPTY <= 1'b1;
    end else begin
        EMPTY <= 1'b0;
    end

    if (SP == 2'd0) begin
        FULL <= 1'b1;
    end else begin
        FULL <= 1'b0;
    end
end

endmodule