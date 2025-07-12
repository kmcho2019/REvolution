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

reg [3:0] stack_mem [0:3];
reg [1:0] SP;

always @(posedge Clk) begin
    if (Rst) begin
        // Reset the buffer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 2'd4;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin
        if (~RW && SP > 2'd0) begin
            // Push data onto the stack
            stack_mem[SP-1] <= dataIn;
            SP <= SP - 1'b1;
        end else if (RW && SP < 2'd4) begin
            // Pop data from the stack
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'd0;
            SP <= SP + 1'b1;
        end
        // Update EMPTY and FULL flags
        EMPTY <= (SP == 2'd4) ? 1'b1 : 1'b0;
        FULL <= (SP == 2'd0) ? 1'b1 : 1'b0;
    end
end

endmodule