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

reg [3:0] stack_mem [0:3]; // Stack memory array to store 4-bit data entries
reg [1:0] SP; // Stack pointer to track the current position in the stack
reg EMPTY_reg, FULL_reg; // Registers for EMPTY and FULL flags
reg [3:0] dataOut_reg; // Register for output data

// Initialize stack memory and stack pointer
initial begin
    for (int i = 0; i < 4; i++) begin
        stack_mem[i] = 4'b0;
    end
    SP = 4;
end

always @(posedge Clk) begin
    if (Rst) begin // Active high reset signal
        // Clear stack memory and set stack pointer to 4 (indicating an empty buffer)
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] = 4'b0;
        end
        SP = 4;
    end else if (EN) begin // Enable signal is high
        if (RW) begin // Read operation
            if (SP < 4) begin // Buffer is not empty
                // Pop data from the stack into dataOut
                dataOut_reg = stack_mem[SP];
                // Clear the corresponding stack memory
                stack_mem[SP] = 4'b0;
                // Increment the stack pointer
                SP = SP + 1;
            end
        end else begin // Write operation
            if (SP > 0) begin // Buffer is not full
                // Decrement the stack pointer
                SP = SP - 1;
                // Push data from dataIn onto the stack
                stack_mem[SP] = dataIn;
            end
        end
    end

    // Update EMPTY and FULL flags
    if (SP == 4) begin
        EMPTY_reg = 1'b1;
        FULL_reg = 1'b0;
    end else if (SP == 0) begin
        EMPTY_reg = 1'b0;
        FULL_reg = 1'b1;
    end else begin
        EMPTY_reg = 1'b0;
        FULL_reg = 1'b0;
    end
end

assign EMPTY = EMPTY_reg;
assign FULL = FULL_reg;
assign dataOut = dataOut_reg;

endmodule