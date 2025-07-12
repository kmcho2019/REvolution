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

reg [3:0] stack_mem [0:3];  // stack memory array
reg [1:0] SP;              // stack pointer
reg [3:0] temp_data;       // temporary data for pop operation

always @ (posedge Clk) begin
    if (Rst) begin
        // reset the stack and stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 2'b11;  // initialize stack pointer to 4 (empty buffer)
    end else if (EN) begin
        if (!RW && (SP != 2'b11)) begin
            // push operation: write data to stack and decrement stack pointer
            stack_mem[SP] <= dataIn;
            SP <= SP - 1'b1;
        end else if (RW && (SP != 2'b00)) begin
            // pop operation: read data from stack, clear stack memory, and increment stack pointer
            temp_data <= stack_mem[SP + 1'b1];
            stack_mem[SP + 1'b1] <= 4'b0;
            SP <= SP + 1'b1;
        end
    end
end

assign dataOut = (RW && (SP != 2'b00)) ? temp_data : 4'b0;  // assign dataOut only during pop operation
assign EMPTY = (SP == 2'b11);  // buffer is empty when stack pointer is at 4
assign FULL = (SP == 2'b00);   // buffer is full when stack pointer is at 0

endmodule