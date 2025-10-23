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
reg [1:0] SP;               // Stack pointer to track current position in the stack
reg EMPTY_reg;              // Register for EMPTY flag
reg FULL_reg;               // Register for FULL flag
reg [3:0] dataOut_reg;      // Register for output data

// Initialize stack pointer and flags
initial begin
    SP = 4'd4;
    EMPTY_reg = 1'b1;
    FULL_reg = 1'b0;
end

// Update stack pointer and flags on each clock cycle
always @ (posedge Clk) begin
    if (Rst) begin  // Reset operation
        SP = 4'd4;
        EMPTY_reg = 1'b1;
        FULL_reg = 1'b0;
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] = 4'd0;
        end
    end else if (EN) begin  // Enable signal is high
        if (RW == 1'b0 && SP!= 4'd0) begin  // Write operation (push data onto stack)
            stack_mem[SP - 1] = dataIn;
            SP = SP - 1'b1;
        end else if (RW == 1'b1 && SP!= 4'd4) begin  // Read operation (pop data from stack)
            dataOut_reg = stack_mem[SP];
            stack_mem[SP] = 4'd0;
            SP = SP + 1'b1;
        end
        // Update EMPTY and FULL flags
        if (SP == 4'd4) begin
            EMPTY_reg = 1'b1;
            FULL_reg = 1'b0;
        end else if (SP == 4'd0) begin
            EMPTY_reg = 1'b0;
            FULL_reg = 1'b1;
        end else begin
            EMPTY_reg = 1'b0;
            FULL_reg = 1'b0;
        end
    end
end

// Continuous assignments for output signals
assign EMPTY = EMPTY_reg;
assign FULL = FULL_reg;
assign dataOut = (RW == 1'b1 && SP!= 4'd4)? dataOut_reg : 4'd0;

endmodule