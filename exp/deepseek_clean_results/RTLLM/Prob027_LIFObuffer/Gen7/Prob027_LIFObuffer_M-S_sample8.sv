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
    reg [1:0] SP;  // 2-bit stack pointer (0-3)

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 2'd3;  // Initialize to empty (pointing past last entry)
            EMPTY <= 1'b1;
            FULL <= 1'b0;
        end
        else if (EN) begin
            // Write operation (push)
            if (!RW && !FULL) begin
                stack_mem[SP] <= dataIn;
                SP <= SP - 1;
            end
            // Read operation (pop)
            else if (RW && !EMPTY) begin
                dataOut <= stack_mem[SP+1];
                SP <= SP + 1;
            end
            
            // Update flags
            EMPTY <= (SP == 2'd3);
            FULL <= (SP == 2'd0);
        end
    end

endmodule