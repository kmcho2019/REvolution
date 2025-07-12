module LIFObuffer(
    input [3:0] dataIn, // 4-bit input data to be pushed onto the buffer
    input RW, // Read/Write control signal (1 for read, 0 for write)
    input EN, // Enable signal to activate buffer operations
    input Rst, // Active high reset signal to initialize the buffer
    input Clk, // Clock signal for synchronous operations
    output EMPTY, // Flag indicating whether the buffer is empty
    output FULL, // Flag indicating whether the buffer is full
    output [3:0] dataOut // 4-bit output data retrieved from the buffer
);

reg [3:0] stack_mem [0:3]; // stack memory array to store the data
reg [1:0] SP; // stack pointer to track the current position in the stack
reg EMPTY_reg, FULL_reg; // registers to store the EMPTY and FULL flags
reg [3:0] dataOut_reg; // register to store the output data

assign EMPTY = EMPTY_reg; // assign the EMPTY flag to the output
assign FULL = FULL_reg; // assign the FULL flag to the output
assign dataOut = dataOut_reg; // assign the output data to the output

always @(posedge Clk) begin
    if (Rst) begin // if reset signal is high, clear the stack and initialize the stack pointer
        SP <= 4;
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        EMPTY_reg <= 1'b1; // set EMPTY flag to 1 (buffer is empty)
        FULL_reg <= 1'b0; // set FULL flag to 0 (buffer is not full)
        dataOut_reg <= 4'b0; // clear output data
    end else if (EN) begin // if enable signal is high
        if (~RW) begin // if RW is low (write operation)
            if (SP!= 0) begin // if buffer is not full
                stack_mem[SP - 1] <= dataIn; // push data onto the stack
                SP <= SP - 1; // decrement stack pointer
                EMPTY_reg <= 1'b0; // set EMPTY flag to 0 (buffer is not empty)
                if (SP == 0) begin // if buffer is full
                    FULL_reg <= 1'b1;
                end else begin
                    FULL_reg <= 1'b0;
                end
            end
        end else begin // if RW is high (read operation)
            if (SP!= 4) begin // if buffer is not empty
                dataOut_reg <= stack_mem[SP]; // pop data from the stack
                stack_mem[SP] <= 4'b0; // clear the corresponding stack memory
                SP <= SP + 1; // increment stack pointer
                FULL_reg <= 1'b0; // set FULL flag to 0 (buffer is not full)
                if (SP == 4) begin // if buffer is empty
                    EMPTY_reg <= 1'b1;
                end else begin
                    EMPTY_reg <= 1'b0;
                end
            end
        end
    end
end

endmodule