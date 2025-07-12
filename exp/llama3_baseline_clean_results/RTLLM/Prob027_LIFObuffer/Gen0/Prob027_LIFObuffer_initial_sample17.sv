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

reg [3:0] stack_mem [3:0]; // stack memory array
reg [1:0] SP; // stack pointer
reg EMPTY_reg, FULL_reg; // flags for EMPTY and FULL
reg [3:0] dataOut_reg; // output data register

// Initialize the stack pointer and flags
always @(posedge Clk) begin
    if (Rst) begin
        SP <= 4; // initialize stack pointer to 4 (empty buffer)
        EMPTY_reg <= 1; // set EMPTY flag
        FULL_reg <= 0; // clear FULL flag
        dataOut_reg <= 0; // clear output data register
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 0; // clear stack memory
        end
    end else if (EN) begin
        if (~RW && ~FULL_reg) begin // write operation and buffer is not full
            stack_mem[SP] <= dataIn; // push data onto the stack
            SP <= SP - 1; // decrement stack pointer
            if (SP == 0) begin // check if buffer is full
                FULL_reg <= 1; // set FULL flag
            end
            EMPTY_reg <= 0; // clear EMPTY flag
        end else if (RW && ~EMPTY_reg) begin // read operation and buffer is not empty
            dataOut_reg <= stack_mem[SP + 1]; // pop data from the stack
            stack_mem[SP + 1] <= 0; // clear the corresponding stack memory
            SP <= SP + 1; // increment stack pointer
            if (SP == 4) begin // check if buffer is empty
                EMPTY_reg <= 1; // set EMPTY flag
            end
            FULL_reg <= 0; // clear FULL flag
        end
    end
end

assign EMPTY = EMPTY_reg;
assign FULL = FULL_reg;
assign dataOut = dataOut_reg;

endmodule