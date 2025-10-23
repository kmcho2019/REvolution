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

reg [3:0] stack_mem [3:0];
reg [1:0] SP;
reg [3:0] dataOut_reg;

assign EMPTY = (SP == 4);
assign FULL = (SP == 0);
assign dataOut = dataOut_reg;

always @(posedge Clk) begin
    if (Rst) begin
        // Initialize the stack and reset the stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 4;
        dataOut_reg <= 4'b0;
    end else if (EN) begin
        if (~RW && (SP!= 0)) begin
            // Push data onto the stack if it's not full
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && (SP!= 4)) begin
            // Pop data from the stack if it's not empty
            dataOut_reg <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

endmodule