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
reg [3:0] dataOut_reg; // internal register for dataOut

// Initialize EMPTY and FULL flags
assign EMPTY = (SP == 4);
assign FULL = (SP == 0);

always @(posedge Clk) begin
    if (Rst) begin
        // Clear stack, set stack pointer, and initialize memory locations to 0
        for (int i = 0; i <= 3; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 4;
    end else if (EN) begin
        if (!FULL && ~RW) begin
            // Push data onto stack during write operation
            stack_mem[SP] <= dataIn;
            SP <= SP - 1;
        end else if (!EMPTY && RW) begin
            // Pop data from stack during read operation
            dataOut_reg <= stack_mem[SP + 1];
            stack_mem[SP + 1] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

assign dataOut = dataOut_reg;

endmodule