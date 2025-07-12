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

reg [3:0] stack_mem [0:3]; // stack memory array
reg [1:0] SP; // stack pointer

always @(posedge Clk) begin
    if (EN) begin
        if (Rst) begin // reset operation
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'b0; // clear stack memory
            end
            SP <= 4; // set stack pointer to 4 (empty buffer)
        end else begin // normal operation
            if (!RW && (SP!= 0)) begin // write operation
                stack_mem[SP - 1] <= dataIn; // push data onto stack
                SP <= SP - 1; // decrement stack pointer
            end else if (RW && (SP!= 4)) begin // read operation
                dataOut <= stack_mem[SP]; // pop data from stack
                stack_mem[SP] <= 4'b0; // clear stack memory
                SP <= SP + 1; // increment stack pointer
            end
        end
    end
end

assign EMPTY = (SP == 4); // buffer is empty
assign FULL = (SP == 0); // buffer is full

endmodule