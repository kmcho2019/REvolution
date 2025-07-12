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

    // Internal stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (2 bits sufficient for 0-3, + empty state)
    reg [1:0] SP;

    // Combinational flag logic
    always @(*) begin
        EMPTY = (SP == 2'b11);  // SP=3 means empty (after reset)
        FULL = (SP == 2'b00);   // SP=0 means full
    end

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition: set SP to 3 (empty)
            SP <= 2'b11;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[SP] <= dataIn;
                SP <= SP - 1;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= stack_mem[SP + 1];
                SP <= SP + 1;
            end
        end
    end

endmodule