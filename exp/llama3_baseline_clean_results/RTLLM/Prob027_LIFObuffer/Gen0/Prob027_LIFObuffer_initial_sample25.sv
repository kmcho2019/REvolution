module LIFObuffer(
    input [3:0] dataIn,
    input RW, EN, Rst, Clk,
    output reg EMPTY, FULL,
    output reg [3:0] dataOut
);

reg [3:0] stack_mem [3:0];  // stack memory array
reg [1:0] SP;  // stack pointer

always @(posedge Clk) begin
    if (Rst) begin
        // Clear stack and reset stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 0;
        end
        SP <= 4;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
        dataOut <= 0;
    end
    else if (EN) begin
        if (RW == 0) begin  // Write operation
            if (SP > 0) begin
                // Push data onto the stack
                stack_mem[SP - 1] <= dataIn;
                SP <= SP - 1;
                EMPTY <= (SP == 4) ? 1'b1 : 1'b0;
                FULL <= (SP == 0) ? 1'b1 : 1'b0;
            end
        end
        else if (RW == 1) begin  // Read operation
            if (SP < 4) begin
                // Pop data from the stack
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= 0;
                SP <= SP + 1;
                EMPTY <= (SP == 4) ? 1'b1 : 1'b0;
                FULL <= (SP == 0) ? 1'b1 : 1'b0;
            end
        end
    end
end

endmodule