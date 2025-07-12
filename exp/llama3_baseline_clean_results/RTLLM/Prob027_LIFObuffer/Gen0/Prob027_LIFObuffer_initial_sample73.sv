module LIFObuffer(
    input logic Clk,
    input logic Rst,
    input logic EN,
    input logic RW,
    input logic [3:0] dataIn,
    output logic EMPTY,
    output logic FULL,
    output logic [3:0] dataOut
);

logic [3:0] stack_mem [3:0]; // stack memory array
logic [1:0] SP; // stack pointer

// initialization of stack pointer
initial begin
    SP = 4;
end

// synchronous operations
always_ff @(posedge Clk) begin
    if (Rst) begin
        // reset operation
        SP <= 4;
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 0;
        end
    end else if (EN) begin
        // check if buffer is full
        if (RW == 0 && SP!= 0) begin
            // write operation
            stack_mem[SP-1] <= dataIn;
            SP <= SP - 1;
        end else if (RW == 1 && SP!= 4) begin
            // read operation
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 0;
            SP <= SP + 1;
        end
    end
end

// update EMPTY and FULL flags
always_comb begin
    EMPTY = (SP == 4);
    FULL = (SP == 0);
end

endmodule