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

    // Stack memory (4 entries, each 4 bits)
    reg [3:0] stack_mem [0:3];
    
    // Stack pointer (0-3)
    reg [1:0] SP;

    // Combinational flags
    assign EMPTY = (SP == 2'd0);
    assign FULL = (SP == 2'd3);

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition
            SP <= 2'd0;
            dataOut <= 4'b0;
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
                SP <= SP - 1;
            end
        end
    end

endmodule