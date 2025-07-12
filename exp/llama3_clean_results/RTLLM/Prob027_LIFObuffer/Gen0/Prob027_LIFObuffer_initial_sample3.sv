module LIFObuffer(
    input         Clk,
    input         Rst,
    input         EN,
    input         RW,
    input  [3:0]  dataIn,
    output [3:0]  dataOut,
    output        EMPTY,
    output        FULL
);

reg [3:0] stack_mem [3:0];
reg [1:0] SP;
reg [3:0] dataOut_reg;

assign EMPTY = (SP == 4);
assign FULL = (SP == 0);

always @(posedge Clk) begin
    if (Rst) begin
        // Initialize stack pointer and clear stack memory
        SP <= 4;
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
    end else if (EN) begin
        if (~RW && ~FULL) begin
            // Write (push) operation: decrement SP and store dataIn in stack
            stack_mem[SP] <= dataIn;
            SP <= SP - 1;
        end else if (RW && ~EMPTY) begin
            // Read (pop) operation: load data from stack into dataOut_reg and increment SP
            dataOut_reg <= stack_mem[SP + 1];
            stack_mem[SP + 1] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

always @(posedge Clk) begin
    dataOut <= dataOut_reg;
end

endmodule