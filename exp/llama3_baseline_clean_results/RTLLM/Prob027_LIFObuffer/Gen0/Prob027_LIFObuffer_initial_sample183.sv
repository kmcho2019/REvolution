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
reg [3:0] dataOut_reg; // internal dataOut register

assign EMPTY = (SP == 4)? 1'b1 : 1'b0; // buffer is empty when SP is 4
assign FULL = (SP == 0)? 1'b1 : 1'b0; // buffer is full when SP is 0

always @ (posedge Clk) begin
    if (Rst) begin // active high reset
        SP <= 4; // initialize SP to 4 (empty buffer)
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0; // clear all memory locations
        end
    end else if (EN) begin // enable buffer operations
        if (!RW &&!FULL) begin // push operation (write)
            stack_mem[SP - 1] <= dataIn; // store data in stack memory
            SP <= SP - 1; // decrement SP
        end else if (RW &&!EMPTY) begin // pop operation (read)
            dataOut_reg <= stack_mem[SP]; // retrieve data from stack memory
            stack_mem[SP] <= 4'b0; // clear retrieved memory location
            SP <= SP + 1; // increment SP
        end
    end
end

assign dataOut = dataOut_reg; // assign internal dataOut register to output

endmodule