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

reg [3:0] stack_mem[3:0]; // stack memory array
reg [1:0] SP; // stack pointer (2 bits for 4 positions)

always @ (posedge Clk) begin
    if (Rst) begin // reset operation
        // clear the stack, set SP to 4 (empty buffer), and initialize memory to 0
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 2'b11; // set SP to 4 (decimal) or 11 (binary)
        EMPTY <= 1'b1; // buffer is empty after reset
        FULL <= 1'b0; // buffer is not full after reset
        dataOut <= 4'b0; // reset dataOut
    end else if (EN) begin // enable signal is high
        if (!RW) begin // write operation
            if (SP != 0) begin // buffer is not full
                stack_mem[SP - 1] <= dataIn; // push data onto the stack
                SP <= SP - 1; // decrement stack pointer
                FULL <= (SP == 0) ? 1'b1 : 1'b0; // update FULL flag
            end else begin
                // buffer is full, no operation
            end
            EMPTY <= (SP == 4) ? 1'b1 : 1'b0; // update EMPTY flag
        end else begin // read operation
            if (SP != 4) begin // buffer is not empty
                dataOut <= stack_mem[SP]; // pop data from the stack
                stack_mem[SP] <= 4'b0; // clear the popped data
                SP <= SP + 1; // increment stack pointer
                EMPTY <= (SP == 4) ? 1'b1 : 1'b0; // update EMPTY flag
            end else begin
                // buffer is empty, no operation
            end
            FULL <= (SP == 0) ? 1'b1 : 1'b0; // update FULL flag
        end
    end else begin
        // no operation when enable signal is low
    end
end

endmodule