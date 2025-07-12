module LIFObuffer(
    input [3:0] dataIn,
    input RW, EN, Rst, Clk,
    output reg EMPTY, FULL,
    output reg [3:0] dataOut
);

reg [3:0] stack_mem [3:0]; // stack memory array
reg [1:0] SP; // stack pointer

always @(posedge Clk) begin
    if (Rst) begin // reset signal high
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0; // clear stack memory
        end
        SP <= 4; // reset stack pointer to 4
        EMPTY <= 1'b1; // set EMPTY flag high
        FULL <= 1'b0; // set FULL flag low
        dataOut <= 4'b0; // reset dataOut
    end else if (EN) begin // enable signal high
        if (RW) begin // read operation
            if (SP < 4) begin // buffer not empty
                dataOut <= stack_mem[SP]; // pop data from stack
                stack_mem[SP] <= 4'b0; // clear stack memory
                SP <= SP + 1; // increment stack pointer
            end
        end else begin // write operation
            if (SP > 0) begin // buffer not full
                SP <= SP - 1; // decrement stack pointer
                stack_mem[SP] <= dataIn; // push data onto stack
            end
        end
        case (SP)
            4: EMPTY <= 1'b1; FULL <= 1'b0; // buffer empty
            0: EMPTY <= 1'b0; FULL <= 1'b1; // buffer full
            default: EMPTY <= 1'b0; FULL <= 1'b0; // buffer neither empty nor full
        endcase
    end
end

endmodule