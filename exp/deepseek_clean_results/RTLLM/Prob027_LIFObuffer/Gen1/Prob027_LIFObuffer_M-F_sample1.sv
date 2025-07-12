module LIFObuffer (
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

    reg [3:0] stack_mem [0:3];  // 4-entry stack memory
    reg [2:0] SP;               // Stack pointer (0-4)

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition
            SP <= 3'd4;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[SP] <= dataIn;
                SP <= SP + 1;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= stack_mem[SP-1];
                stack_mem[SP-1] <= 4'b0;  // Clear the popped location
                SP <= SP - 1;
            end

            // Update flags
            EMPTY <= (SP == 3'd0);
            FULL <= (SP == 3'd4);
        end
    end

endmodule