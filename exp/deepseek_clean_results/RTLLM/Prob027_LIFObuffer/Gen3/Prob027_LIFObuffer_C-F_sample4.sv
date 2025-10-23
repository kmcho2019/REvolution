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

    // Stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (4 indicates empty, 0 indicates full)
    // Using 2 bits since we only need to represent 0-4 (5 states)
    reg [1:0] SP;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition: set SP to empty (4)
            // Memory initialization not strictly necessary for functionality
            SP <= 2'd3;  // Special encoding: 3 represents 4 (empty)
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[SP] <= dataIn;
                SP <= SP - 1;
                EMPTY <= 1'b0;
                FULL <= (SP == 0);  // Will be full after this push
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                // Note: Not clearing memory as it will be overwritten on next push
                dataOut <= stack_mem[SP+1];
                SP <= SP + 1;
                FULL <= 1'b0;
                EMPTY <= (SP == 2);  // 2 represents 3 in our encoding
            end
        end
        // For power optimization: could add clock gating when EN=0
    end

    // Special encoding for SP:
    // SP value | Actual position
    // 0        | 0 (full)
    // 1        | 1
    // 2        | 2
    // 3        | 3 (empty)
    // Note: SP=3 represents position 4 (empty) in original design

endmodule