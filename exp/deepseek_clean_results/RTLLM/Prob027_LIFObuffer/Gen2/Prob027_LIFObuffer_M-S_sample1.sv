module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output wire EMPTY,
    output wire FULL,
    output reg [3:0] dataOut
);

    // Stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (0-4)
    reg [2:0] SP;

    // Flags are simple comparisons
    assign EMPTY = (SP == 0);
    assign FULL = (SP == 4);

    always @(posedge Clk) begin
        if (Rst) begin
            // Clear stack pointer and memory on reset
            SP <= 0;
            stack_mem[0] <= 0;
            stack_mem[1] <= 0;
            stack_mem[2] <= 0;
            stack_mem[3] <= 0;
            dataOut <= 0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin  // Write operation
                stack_mem[SP] <= dataIn;
                SP <= SP + 1;
            end
            else if (RW && !EMPTY) begin  // Read operation
                dataOut <= stack_mem[SP-1];
                stack_mem[SP-1] <= 0;  // Clear the read location
                SP <= SP - 1;
            end
        end
    end

endmodule