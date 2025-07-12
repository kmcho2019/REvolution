module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

reg [3:0] stack_mem [3:0]; // stack memory array
reg [1:0] SP; // stack pointer

always @ (posedge Clk) begin
    if (Rst) begin
        // reset the stack and stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 4;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin
        // check for push operation (RW = 0)
        if (!RW && !FULL) begin
            // push data onto the stack
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
            // update flags
            EMPTY <= (SP == 4) ? 1'b1 : 1'b0;
            FULL <= (SP == 0) ? 1'b1 : 1'b0;
        end
        // check for pop operation (RW = 1)
        else if (RW && !EMPTY) begin
            // pop data from the stack
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
            // update flags
            EMPTY <= (SP == 4) ? 1'b1 : 1'b0;
            FULL <= (SP == 0) ? 1'b1 : 1'b0;
        end
    end
end

assign EMPTY = (SP == 4) ? 1'b1 : 1'b0;
assign FULL = (SP == 0) ? 1'b1 : 1'b0;

endmodule