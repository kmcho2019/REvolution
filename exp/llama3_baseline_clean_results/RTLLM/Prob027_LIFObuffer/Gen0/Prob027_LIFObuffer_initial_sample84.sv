module LIFObuffer(
    input [3:0] dataIn,  // 4-bit input data to be pushed onto the buffer
    input RW,  // Read/Write control signal (1 for read, 0 for write)
    input EN,  // Enable signal to activate buffer operations
    input Rst,  // Active high reset signal to initialize the buffer
    input Clk,  // Clock signal for synchronous operations
    output EMPTY,  // Flag indicating whether the buffer is empty
    output FULL,  // Flag indicating whether the buffer is full
    output [3:0] dataOut  // 4-bit output data retrieved from the buffer
);

reg [3:0] stack_mem [3:0];  // stack memory array to store the data
reg [1:0] SP;  // stack pointer to track the current position in the stack
reg [3:0] dataOut_reg;  // register to hold the output data

always @(posedge Clk) begin
    if (Rst) begin
        // reset the buffer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;  // initialize all memory locations to 0
        end
        SP <= 2'b11;  // set the stack pointer to 4 (indicating an empty buffer)
    end else if (EN) begin
        if (RW == 0 && SP!= 2'b00) begin
            // push data onto the stack
            stack_mem[SP] <= dataIn;
            SP <= SP - 1'b1;  // decrement the stack pointer
        end else if (RW == 1 && SP!= 2'b11) begin
            // pop data from the stack
            dataOut_reg <= stack_mem[SP + 1'b1];  // retrieve the data from the stack
            stack_mem[SP + 1'b1] <= 4'b0;  // clear the corresponding stack memory
            SP <= SP + 1'b1;  // increment the stack pointer
        end
    end
end

always @(*) begin
    // update the EMPTY and FULL flags
    EMPTY = (SP == 2'b11)? 1'b1 : 1'b0;  // buffer is empty if SP is 4
    FULL = (SP == 2'b00)? 1'b1 : 1'b0;  // buffer is full if SP is 0
    dataOut = dataOut_reg;  // assign the output data
end

endmodule