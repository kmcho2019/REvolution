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
    
    // Stack pointer (3 bits, 4 means empty, 0 means full)
    reg [2:0] SP;

    // Combinational flag assignments
    assign EMPTY = (SP == 3'd4);
    assign FULL = (SP == 3'd0);

    // Stack operations
    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition: clear stack and set SP to empty
            SP <= 3'd4;
            dataOut <= 4'b0;
            // Initialize memory locations
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
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