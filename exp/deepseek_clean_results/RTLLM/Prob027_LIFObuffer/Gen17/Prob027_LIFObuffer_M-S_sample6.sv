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

    // Packed stack memory (4 entries x 4 bits)
    reg [3:0] stack_mem [0:3];
    
    // Stack pointer (0-4)
    reg [2:0] SP;

    // Combinational flag assignments
    assign EMPTY = (SP == 0);
    assign FULL = (SP == 4);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 0;
            dataOut <= 0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Push operation
                stack_mem[SP] <= dataIn;
                SP <= SP + 1;
            end
            else if (RW && !EMPTY) begin
                // Pop operation
                dataOut <= stack_mem[SP-1];
                SP <= SP - 1;
            end
        end
    end

endmodule