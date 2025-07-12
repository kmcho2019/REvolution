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

    // Stack memory (4 entries, each 4 bits)
    reg [3:0] stack_mem [0:3];
    
    // Stack pointer (2 bits sufficient for 0-4)
    reg [1:0] SP;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition
            SP <= 2'd3;  // 3 means empty (next write at 2)
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
            // Memory will initialize to unknown, which is fine
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[SP] <= dataIn;
                SP <= SP - 1;
                EMPTY <= 1'b0;
                FULL <= (SP == 0);
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= stack_mem[SP+1];
                SP <= SP + 1;
                FULL <= 1'b0;
                EMPTY <= (SP == 2);
            end
        end
    end

endmodule