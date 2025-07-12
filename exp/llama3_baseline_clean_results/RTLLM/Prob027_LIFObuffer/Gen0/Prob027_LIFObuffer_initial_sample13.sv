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

reg [3:0] stack_mem [0:3];
reg [1:0] SP; // Stack Pointer (0-3)
reg [3:0] dataOut_reg;

assign EMPTY = (SP == 4'd4);
assign FULL = (SP == 4'd0);

always @ (posedge Clk) begin
    if (Rst) begin
        // Reset: Clear the stack, set SP to 4, and initialize memory locations to 0
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0000;
        end
        SP <= 4'd4;
    end else if (EN) begin
        if (~RW && ~FULL) begin
            // Push data onto the stack if not full
            stack_mem[SP] <= dataIn;
            SP <= SP - 1'b1;
        end else if (RW && ~EMPTY) begin
            // Pop data from the stack if not empty
            dataOut_reg <= stack_mem[SP + 1'b1];
            stack_mem[SP + 1'b1] <= 4'b0000;
            SP <= SP + 1'b1;
        end
    end
end

assign dataOut = dataOut_reg;

endmodule