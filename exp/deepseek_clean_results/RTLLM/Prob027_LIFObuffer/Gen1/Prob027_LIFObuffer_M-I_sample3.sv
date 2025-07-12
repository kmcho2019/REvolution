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

    // Parameters for stack pointer states
    localparam SP_EMPTY = 3'd4;
    localparam SP_FULL = 3'd0;
    
    // Internal memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (4 means empty, 0 means full)
    reg [2:0] SP;
    
    // Flags are now combinational
    assign EMPTY = (SP == SP_EMPTY);
    assign FULL = (SP == SP_FULL);

    integer i; // For reset initialization
    
    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition
            SP <= SP_EMPTY;
            dataOut <= 4'b0;
            // Clear all memory locations using loop
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'b0;
            end
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