module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

reg [3:0] stack_mem[0:3]; // stack memory array
reg [1:0] SP; // stack pointer

always @ (posedge Clk) begin
    if (Rst) begin // reset operation
        SP <= 4; // set stack pointer to 4 (empty buffer)
        for (int i = 0; i <= 3; i++) begin
            stack_mem[i] <= 4'b0; // initialize memory locations to 0
        end
        EMPTY <= 1'b1; // set EMPTY flag to 1
        FULL <= 1'b0; // set FULL flag to 0
        dataOut <= 4'b0; // reset dataOut
    end else if (EN) begin // enable buffer operations
        if (!RW && (SP != 0)) begin // write operation and buffer not full
            stack_mem[SP - 1] <= dataIn; // push data onto stack
            SP <= SP - 1; // decrement stack pointer
        end else if (RW && (SP != 4)) begin // read operation and buffer not empty
            dataOut <= stack_mem[SP]; // pop data from stack
            stack_mem[SP] <= 4'b0; // clear corresponding stack memory
            SP <= SP + 1; // increment stack pointer
        end
        if (SP == 4) begin // update EMPTY flag
            EMPTY <= 1'b1;
        end else begin
            EMPTY <= 1'b0;
        end
        if (SP == 0) begin // update FULL flag
            FULL <= 1'b1;
        end else begin
            FULL <= 1'b0;
        end
    end
end

endmodule