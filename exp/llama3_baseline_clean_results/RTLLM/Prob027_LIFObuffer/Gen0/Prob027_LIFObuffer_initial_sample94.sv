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

reg [3:0] stack_mem [3:0];  // stack memory array
reg [1:0] SP;  // stack pointer
reg EMPTY, FULL;

always @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack and stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 4;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin
        // Check if the buffer is full or empty
        if (~RW && ~FULL) begin
            // Push data onto the stack
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && ~EMPTY) begin
            // Pop data from the stack
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

always @(*) begin
    // Update EMPTY and FULL flags
    if (SP == 4) begin
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (SP == 0) begin
        EMPTY <= 1'b0;
        FULL <= 1'b1;
    end else begin
        EMPTY <= 1'b0;
        FULL <= 1'b0;
    end
end

assign dataOut = (EMPTY) ? 4'b0 : stack_mem[SP];

endmodule