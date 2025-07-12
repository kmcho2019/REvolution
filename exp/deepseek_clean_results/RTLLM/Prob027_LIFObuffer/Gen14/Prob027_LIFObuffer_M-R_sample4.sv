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
    
    // Binary stack pointer (3 bits, range 0-4)
    reg [2:0] SP;

    // Combinational flag logic
    assign EMPTY = (SP == 3'b000);
    assign FULL = (SP == 3'b100);

    // Combinational memory read
    always @(*) begin
        if (!EMPTY)
            dataOut = stack_mem[SP-1];
        else
            dataOut = 4'b0;
    end

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition: set SP to empty
            SP <= 3'b000;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[SP] <= dataIn;
                SP <= SP + 1;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                SP <= SP - 1;
            end
        end
    end

endmodule