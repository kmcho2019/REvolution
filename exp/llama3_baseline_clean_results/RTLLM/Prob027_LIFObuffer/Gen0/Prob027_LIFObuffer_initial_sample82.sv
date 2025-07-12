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

reg [3:0] stack_mem [3:0]; // stack memory
reg [3:0] dataOut_reg; // register for output data
integer SP; // stack pointer

assign EMPTY = (SP == 4);
assign FULL = (SP == 0);

always @(posedge Clk) begin
    if (Rst) begin
        // reset the stack
        for (integer i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 4;
    end else if (EN) begin
        if (!RW &&!FULL) begin
            // push data onto the stack
            stack_mem[SP-1] <= dataIn;
            SP <= SP - 1;
        end else if (RW &&!EMPTY) begin
            // pop data from the stack
            dataOut_reg <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

always @(*) begin
    if (EMPTY) begin
        dataOut = 4'b0;
    end else begin
        dataOut = dataOut_reg;
    end
end

endmodule