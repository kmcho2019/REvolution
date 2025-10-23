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

reg [3:0] stack_mem [0:3];  // 4-entry deep, 4-bit wide stack memory
reg [1:0] SP;  // Stack pointer (0 to 3)
reg [3:0] dataOut_reg;  // Register to hold output data

always @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack, set stack pointer to 4 (indicating empty buffer)
        SP <= 2'd4;
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
    end else if (EN) begin
        if (~RW && (SP!= 2'd0)) begin
            // Push data onto the stack, decrement stack pointer
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && (SP!= 2'd4)) begin
            // Pop data from the stack, increment stack pointer, clear memory location
            dataOut_reg <= stack_mem[SP];
            stack_mem[SP] <= 4'd0;
            SP <= SP + 1;
        end
    end
end

assign dataOut = (EN && RW && (SP!= 2'd4))? dataOut_reg : 4'd0;
assign EMPTY = (SP == 2'd4);
assign FULL = (SP == 2'd0);

endmodule