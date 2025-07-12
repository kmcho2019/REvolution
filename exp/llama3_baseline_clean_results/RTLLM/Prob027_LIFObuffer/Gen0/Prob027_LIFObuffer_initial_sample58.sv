module LIFObuffer(
    input [3:0] dataIn,  // 4-bit input data to be pushed onto the buffer
    input RW,            // Read/Write control signal (1 for read, 0 for write)
    input EN,            // Enable signal to activate buffer operations
    input Rst,           // Active high reset signal to initialize the buffer
    input Clk,           // Clock signal for synchronous operations
    output EMPTY,        // Flag indicating whether the buffer is empty
    output FULL,         // Flag indicating whether the buffer is full
    output [3:0] dataOut // 4-bit output data retrieved from the buffer
);

reg [3:0] stack_mem [0:3];  // Stack memory array to store data
reg [1:0] SP;              // Stack pointer to track current position
reg EMPTY_reg, FULL_reg;   // Registers to store EMPTY and FULL flags
reg [3:0] dataOut_reg;     // Register to store output data

// Initialize stack memory and flags
initial begin
    for (int i = 0; i < 4; i++) begin
        stack_mem[i] = 4'b0;
    end
    SP = 4;
    EMPTY_reg = 1'b1;
    FULL_reg = 1'b0;
    dataOut_reg = 4'b0;
end

always @(posedge Clk) begin
    if (Rst) begin
        // Reset stack and flags
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] = 4'b0;
        end
        SP = 4;
        EMPTY_reg = 1'b1;
        FULL_reg = 1'b0;
        dataOut_reg = 4'b0;
    end else if (EN) begin
        if (~RW && SP!= 0) begin
            // Write data to stack (push)
            stack_mem[SP - 1] = dataIn;
            SP = SP - 1;
        end else if (RW && SP!= 4) begin
            // Read data from stack (pop)
            dataOut_reg = stack_mem[SP];
            stack_mem[SP] = 4'b0;
            SP = SP + 1;
        end
    end

    // Update flags
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