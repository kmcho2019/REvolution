module LIFObuffer(
    input dataIn, // 4-bit input data to be pushed onto the buffer
    input RW, // Read/Write control signal (1 for read, 0 for write)
    input EN, // Enable signal to activate buffer operations
    input Rst, // Active high reset signal to initialize the buffer
    input Clk, // Clock signal for synchronous operations
    output EMPTY, // Flag indicating whether the buffer is empty
    output FULL, // Flag indicating whether the buffer is full
    output [3:0] dataOut // 4-bit output data retrieved from the buffer
);

reg [3:0] stack_mem [0:3]; // stack memory array to store data
reg [1:0] SP; // stack pointer to track current position

assign EMPTY = (SP == 4); // flag to indicate if buffer is empty
assign FULL = (SP == 0); // flag to indicate if buffer is full

always @(posedge Clk) begin
    if (Rst) begin // reset the buffer
        SP <= 4; // set stack pointer to indicate empty buffer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0; // initialize all memory locations to 0
        end
    end else if (EN) begin // perform buffer operations if enabled
        if (!RW &&!FULL) begin // push data onto the stack if not full
            stack_mem[SP - 1] <= dataIn; // push data onto the stack
            SP <= SP - 1; // decrement stack pointer
        end else if (RW &&!EMPTY) begin // pop data from the stack if not empty
            dataOut <= stack_mem[SP]; // pop data from the stack
            stack_mem[SP] <= 4'd0; // clear the corresponding stack memory
            SP <= SP + 1; // increment stack pointer
        end
    end
end

endmodule