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

reg [3:0] stack_mem [0:3]; // stack memory array
reg [1:0] SP; // stack pointer
reg EMPTY_reg, FULL_reg; // registers for EMPTY and FULL flags
reg [3:0] dataOut_reg; // register for dataOut

assign EMPTY = EMPTY_reg; // continuous assignment for EMPTY flag
assign FULL = FULL_reg; // continuous assignment for FULL flag
assign dataOut = dataOut_reg; // continuous assignment for dataOut

always @ (posedge Clk) begin
    if (Rst) begin // reset operation
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0; // initialize stack memory to 0
        end
        SP <= 2'b11; // set stack pointer to 3 (indicating an empty buffer)
        EMPTY_reg <= 1'b1; // set EMPTY flag to high
        FULL_reg <= 1'b0; // set FULL flag to low
    end else if (EN) begin // buffer operation
        if (~RW && ~FULL_reg) begin // push operation
            stack_mem[SP] <= dataIn; // push data onto the stack
            SP <= SP - 1'b1; // decrement stack pointer
            EMPTY_reg <= 1'b0; // clear EMPTY flag
            if (SP == 2'b00) begin // check if buffer is full
                FULL_reg <= 1'b1; // set FULL flag to high
            end
        end else if (RW && ~EMPTY_reg) begin // pop operation
            dataOut_reg <= stack_mem[SP + 1'b1]; // pop data from the stack
            stack_mem[SP + 1'b1] <= 4'b0; // clear popped data
            SP <= SP + 1'b1; // increment stack pointer
            FULL_reg <= 1'b0; // clear FULL flag
            if (SP == 2'b11) begin // check if buffer is empty
                EMPTY_reg <= 1'b1; // set EMPTY flag to high
            end
        end
    end
end

endmodule