module LIFObuffer(
    input [3:0] dataIn,
    input RW, EN, Rst, Clk,
    output reg EMPTY, FULL,
    output reg [3:0] dataOut
);

    reg [3:0] stack_mem [0:3]; // 4-entry stack memory
    reg [1:0] SP; // stack pointer

    always @(posedge Clk) begin
        if (Rst) begin // reset signal is high
            SP <= 4; // set stack pointer to 4 (indicating an empty buffer)
            for (int i = 0; i < 4; i++) begin // initialize stack memory to 0
                stack_mem[i] <= 4'b0000;
            end
        end else if (EN) begin // enable signal is high
            if (~RW && (SP != 0)) begin // write operation and buffer is not full
                stack_mem[SP - 1] <= dataIn; // push data onto stack
                SP <= SP - 1; // decrement stack pointer
            end else if (RW && (SP != 4)) begin // read operation and buffer is not empty
                dataOut <= stack_mem[SP]; // pop data from stack into dataOut
                stack_mem[SP] <= 4'b0000; // clear corresponding stack memory
                SP <= SP + 1; // increment stack pointer
            end
        end
    end

    always @(*) begin
        if (SP == 4) begin // stack pointer is 4 (indicating an empty buffer)
            EMPTY = 1'b1;
            FULL = 1'b0;
        end else if (SP == 0) begin // stack pointer is 0 (indicating a full buffer)
            EMPTY = 1'b0;
            FULL = 1'b1;
        end else begin // buffer is neither empty nor full
            EMPTY = 1'b0;
            FULL = 1'b0;
        end
    end

endmodule