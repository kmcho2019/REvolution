module LIFObuffer(
    input [3:0] dataIn,  // 4-bit input data to be pushed onto the buffer
    input RW,          // Read/Write control signal (1 for read, 0 for write)
    input EN,          // Enable signal to activate buffer operations
    input Rst,         // Active high reset signal to initialize the buffer
    input Clk,         // Clock signal for synchronous operations
    output EMPTY,      // Flag indicating whether the buffer is empty
    output FULL,       // Flag indicating whether the buffer is full
    output [3:0] dataOut // 4-bit output data retrieved from the buffer
);

reg [3:0] stack_mem [0:3];  // stack memory array
reg [1:0] SP;             // stack pointer

always @(posedge Clk) begin
    if (EN) begin
        if (Rst) begin  // reset operation
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'd0;  // initialize stack memory to 0
            end
            SP <= 2'd4;  // set stack pointer to 4 (indicating an empty buffer)
            dataOut <= 4'd0;  // initialize dataOut to 0
        end else begin  // normal operation
            if (RW == 1'b0 && SP > 2'd0) begin  // write operation
                stack_mem[SP - 1] <= dataIn;  // push data onto the stack
                SP <= SP - 1'b1;  // decrement stack pointer
            end else if (RW == 1'b1 && SP < 2'd4) begin  // read operation
                dataOut <= stack_mem[SP];  // pop data from the stack
                stack_mem[SP] <= 4'd0;  // clear the corresponding stack memory
                SP <= SP + 1'b1;  // increment stack pointer
            end
        end
    end
end

assign EMPTY = (SP == 2'd4);  // buffer is empty when stack pointer is 4
assign FULL = (SP == 2'd0);  // buffer is full when stack pointer is 0

endmodule