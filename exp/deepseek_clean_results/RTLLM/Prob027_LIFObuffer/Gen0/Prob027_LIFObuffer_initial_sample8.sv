module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

    // Stack memory array (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (4 indicates empty, 0 indicates full)
    reg [2:0] SP;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition: clear stack and set SP to empty
            SP <= 3'd4;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[SP-1] <= dataIn;
                SP <= SP - 1;
                EMPTY <= 1'b0;
                FULL <= (SP == 1) ? 1'b1 : 1'b0;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= 4'b0;
                SP <= SP + 1;
                FULL <= 1'b0;
                EMPTY <= (SP == 3) ? 1'b1 : 1'b0;
            end
        end
    end

endmodule