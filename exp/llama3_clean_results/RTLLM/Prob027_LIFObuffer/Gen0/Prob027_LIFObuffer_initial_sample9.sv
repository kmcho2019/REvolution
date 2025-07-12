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
        // Reset the stack, set SP to 4 (empty), and initialize all memory locations to 0
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 4;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin
        // Check for FULL and EMPTY conditions
        if (SP == 4) begin
            EMPTY <= 1'b1;
        end else begin
            EMPTY <= 1'b0;
        end

        if (SP == 0) begin
            FULL <= 1'b1;
        end else begin
            FULL <= 1'b0;
        end

        // Handle write operation
        if (!RW && !FULL) begin
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end
        // Handle read operation
        else if (RW && !EMPTY) begin
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

endmodule