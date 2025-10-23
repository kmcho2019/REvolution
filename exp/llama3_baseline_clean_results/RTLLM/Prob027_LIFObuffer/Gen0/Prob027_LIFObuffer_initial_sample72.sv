module LIFObuffer(
    input [3:0] dataIn,
    input RW, EN, Rst, Clk,
    output EMPTY, FULL,
    output [3:0] dataOut
);

reg [3:0] stack_mem [0:3]; // 4-entry stack memory
reg [1:0] SP; // stack pointer (0-3)
reg [3:0] dataOut_reg; // internal dataOut register

assign EMPTY = (SP == 4'b100); // buffer is empty when SP is 4
assign FULL = (SP == 4'b000); // buffer is full when SP is 0

always @(posedge Clk) begin
    if (Rst) begin // reset
        SP <= 4'b100; // initialize stack pointer to 4
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0; // clear stack memory
        end
        dataOut_reg <= 4'b0; // clear dataOut register
    end else if (EN) begin // enable buffer operations
        if (~RW) begin // write operation
            if (~FULL) begin // buffer is not full
                stack_mem[SP] <= dataIn; // push data onto stack
                SP <= SP - 1; // decrement stack pointer
            end
        end else begin // read operation
            if (~EMPTY) begin // buffer is not empty
                dataOut_reg <= stack_mem[SP + 1]; // pop data from stack into dataOut
                stack_mem[SP + 1] <= 4'b0; // clear popped stack memory location
                SP <= SP + 1; // increment stack pointer
            end
        end
    end
end

assign dataOut = dataOut_reg;

endmodule