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

reg [3:0] stack_mem[0:3]; // stack memory array
reg [1:0] SP; // stack pointer (0-3)
reg [3:0] dataOut_reg; // register to hold output data

// always block for clock edge and operations
always @ (posedge Clk) begin
    if (Rst) begin // active high reset
        // clear stack memory
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 4; // set stack pointer to 4 (indicating empty buffer)
    end else if (EN) begin // enable signal is high
        if (RW == 1'b0 && SP > 0) begin // write operation and buffer is not full
            stack_mem[SP-1] <= dataIn; // push data onto stack
            SP <= SP - 1; // decrement stack pointer
        end else if (RW == 1'b1 && SP < 4) begin // read operation and buffer is not empty
            dataOut_reg <= stack_mem[SP]; // pop data from stack
            stack_mem[SP] <= 4'b0; // clear popped memory location
            SP <= SP + 1; // increment stack pointer
        end
    end
end

// update EMPTY and FULL flags
assign EMPTY = (SP == 4);
assign FULL = (SP == 0);

// assign output data
assign dataOut = dataOut_reg;

endmodule