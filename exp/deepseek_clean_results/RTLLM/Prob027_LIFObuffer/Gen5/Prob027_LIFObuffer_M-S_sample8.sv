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

    // Stack memory (4 entries)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (0-3)
    reg [1:0] SP;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 2'd0;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin  // Write operation
                stack_mem[SP] <= dataIn;
                SP <= SP + 1;
            end
            else if (RW && !EMPTY) begin  // Read operation
                dataOut <= stack_mem[SP-1];
                SP <= SP - 1;
            end

            // Update flags
            EMPTY <= (SP == 2'd0);
            FULL <= (SP == 2'd3);
        end
    end

endmodule