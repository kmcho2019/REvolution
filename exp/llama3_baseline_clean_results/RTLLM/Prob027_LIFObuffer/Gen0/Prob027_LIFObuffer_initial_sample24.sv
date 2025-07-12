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

reg [3:0] stack_mem [0:3]; // stack memory array
reg [1:0] SP; // stack pointer

always @ (posedge Clk) begin
    if (Rst) begin // reset operation
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0; // clear stack memory
        end
        SP <= 2'd4; // set stack pointer to 4 (empty buffer)
        EMPTY <= 1'b1; // set EMPTY flag
        FULL <= 1'b0; // clear FULL flag
    end else if (EN) begin // enable signal is high
        if (!RW && (SP!= 2'd0)) begin // write operation and buffer is not full
            stack_mem[SP - 1] <= dataIn; // push data onto stack
            SP <= SP - 1; // decrement stack pointer
            EMPTY <= 1'b0; // clear EMPTY flag
            if (SP == 2'd0) begin // buffer is full
                FULL <= 1'b1;
            end else begin
                FULL <= 1'b0;
            end
        end else if (RW && (SP!= 2'd4)) begin // read operation and buffer is not empty
            dataOut <= stack_mem[SP]; // pop data from stack
            stack_mem[SP] <= 4'd0; // clear stack memory
            SP <= SP + 1; // increment stack pointer
            FULL <= 1'b0; // clear FULL flag
            if (SP == 2'd4) begin // buffer is empty
                EMPTY <= 1'b1;
            end else begin
                EMPTY <= 1'b0;
            end
        end
    end
end

endmodule