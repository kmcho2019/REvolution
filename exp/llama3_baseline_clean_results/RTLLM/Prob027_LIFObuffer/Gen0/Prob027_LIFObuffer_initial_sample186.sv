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

reg [3:0] stack_mem [0:3]; // 4-entry stack memory array
reg [1:0] SP; // stack pointer
reg EMPTY_reg, FULL_reg; // registers for EMPTY and FULL flags
reg [3:0] dataOut_reg; // register for dataOut

assign EMPTY = EMPTY_reg;
assign FULL = FULL_reg;
assign dataOut = dataOut_reg;

always @(posedge Clk) begin
    if (Rst) begin // reset
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0; // clear stack memory
        end
        SP <= 2'b11; // set stack pointer to 4 (empty buffer)
        EMPTY_reg <= 1'b1; // set EMPTY flag high
        FULL_reg <= 1'b0; // set FULL flag low
    end else if (EN) begin // enable signal is high
        if (!RW && (SP!= 2'b00)) begin // write operation and buffer is not full
            stack_mem[SP] <= dataIn; // push data onto stack
            SP <= SP - 1; // decrement stack pointer
            EMPTY_reg <= 1'b0; // set EMPTY flag low
            if (SP == 2'b00) begin
                FULL_reg <= 1'b1; // set FULL flag high
            end else begin
                FULL_reg <= 1'b0; // set FULL flag low
            end
        end else if (RW && (SP!= 2'b11)) begin // read operation and buffer is not empty
            dataOut_reg <= stack_mem[SP + 1]; // pop data from stack into dataOut
            stack_mem[SP + 1] <= 4'b0; // clear corresponding stack memory
            SP <= SP + 1; // increment stack pointer
            FULL_reg <= 1'b0; // set FULL flag low
            if (SP == 2'b11) begin
                EMPTY_reg <= 1'b1; // set EMPTY flag high
            end else begin
                EMPTY_reg <= 1'b0; // set EMPTY flag low
            end
        end
    end
end

endmodule