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
reg [3:0] dataOut_reg; // register for output data

assign dataOut = dataOut_reg;
assign EMPTY = (SP == 4); // buffer is empty when SP is 4
assign FULL = (SP == 0); // buffer is full when SP is 0

always @ (posedge Clk) begin
    if (Rst) begin // reset operation
        SP <= 4; // set stack pointer to 4 (indicating an empty buffer)
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 0; // clear all memory locations
        end
    end else if (EN) begin // enable signal is high
        if (!RW) begin // write operation
            if (!FULL) begin // buffer is not full
                stack_mem[SP] <= dataIn; // push data onto the stack
                SP <= SP - 1; // decrement stack pointer
            end
        end else begin // read operation
            if (!EMPTY) begin // buffer is not empty
                dataOut_reg <= stack_mem[SP + 1]; // pop data from the stack
                stack_mem[SP + 1] <= 0; // clear the corresponding stack memory
                SP <= SP + 1; // increment stack pointer
            end
        end
    end
end

endmodule