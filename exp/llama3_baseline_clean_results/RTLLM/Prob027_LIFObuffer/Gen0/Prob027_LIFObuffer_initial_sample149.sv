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

reg [3:0] stack_mem [3:0]; // stack memory array
reg [1:0] SP; // stack pointer

always @(posedge Clk) begin
    if (EN) begin
        if (Rst) begin
            // reset the buffer
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'b0; // clear stack memory
            end
            SP <= 4'b100; // set stack pointer to 4 (empty buffer)
            EMPTY <= 1'b1; // set EMPTY flag
            FULL <= 1'b0; // clear FULL flag
        end else begin
            // perform read/write operation
            if (~RW && ~FULL) begin
                // push data onto the stack
                stack_mem[SP - 1] <= dataIn;
                SP <= SP - 1;
                EMPTY <= 1'b0; // clear EMPTY flag
                if (SP == 1'b0) begin
                    FULL <= 1'b1; // set FULL flag
                end
            end else if (RW && ~EMPTY) begin
                // pop data from the stack
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= 4'b0; // clear popped data
                SP <= SP + 1;
                FULL <= 1'b0; // clear FULL flag
                if (SP == 4) begin
                    EMPTY <= 1'b1; // set EMPTY flag
                end
            end
        end
    end
end

endmodule