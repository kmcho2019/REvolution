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

always @(*)
begin
    if (EMPTY)
        dataOut = 4'b0;
    else
        dataOut = stack_mem[SP];
end

always_ff @(posedge Clk)
begin
    if (Rst)
    begin
        stack_mem[0] <= 4'b0;
        stack_mem[1] <= 4'b0;
        stack_mem[2] <= 4'b0;
        stack_mem[3] <= 4'b0;
        SP <= 4;
        dataOut_reg <= 4'b0;
    end
    else if (EN)
    begin
        if (!RW && !FULL)
        begin
            stack_mem[SP-1] <= dataIn;
            SP <= SP - 1;
        end
        else if (RW && !EMPTY)
        begin
            dataOut_reg <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

assign dataOut = dataOut_reg;

endmodule