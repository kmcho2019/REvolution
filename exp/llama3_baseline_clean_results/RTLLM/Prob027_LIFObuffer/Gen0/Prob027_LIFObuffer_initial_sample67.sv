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

reg [3:0] stack_mem [0:3]; // 4-entry deep, 4-bit wide stack memory array
reg [1:0] SP; // stack pointer

always @ (posedge Clk) begin
    if (EN) begin
        if (Rst) begin // reset condition
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 0; // initialize all memory locations to 0
            end
            SP <= 4; // set stack pointer to 4 (indicating an empty buffer)
            EMPTY <= 1'b1; // set EMPTY flag high
            FULL <= 1'b0; // set FULL flag low
            dataOut <= 0; // set dataOut to 0
        end else begin // normal operation
            if (RW == 1'b0 && SP != 0) begin // write operation and buffer not full
                stack_mem[SP-1] <= dataIn; // push data onto the stack
                SP <= SP - 1; // decrement stack pointer
            end
            if (RW == 1'b1 && SP != 4) begin // read operation and buffer not empty
                dataOut <= stack_mem[SP]; // pop data from the stack
                stack_mem[SP] <= 0; // clear the corresponding stack memory
                SP <= SP + 1; // increment stack pointer
            end
            // update EMPTY and FULL flags based on stack pointer status
            if (SP == 4) begin
                EMPTY <= 1'b1;
                FULL <= 1'b0;
            end else if (SP == 0) begin
                EMPTY <= 1'b0;
                FULL <= 1'b1;
            end else begin
                EMPTY <= 1'b0;
                FULL <= 1'b0;
            end
        end
    end
end

endmodule