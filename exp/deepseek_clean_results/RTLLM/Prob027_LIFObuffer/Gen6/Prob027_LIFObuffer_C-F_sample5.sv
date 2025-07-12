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

    // Internal stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (0-4, where 4 means empty)
    reg [2:0] SP;

    // Combinational flag assignments
    assign EMPTY = (SP == 3'd4);
    assign FULL = (SP == 3'd0);

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition - only clear SP, memory will be overwritten
            SP <= 3'd4;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[SP-1] <= dataIn;
                SP <= SP - 1;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= stack_mem[SP];
                SP <= SP + 1;
            end
        end
    end

endmodule