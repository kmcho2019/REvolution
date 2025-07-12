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
    localparam SP_EMPTY = 2'd3;
    localparam SP_FULL = 2'd0;
    
    // Internal memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (2 bits sufficient for 0-3)
    reg [1:0] SP;
    
    // Combinational flag generation
    assign EMPTY = (SP == SP_EMPTY);
    assign FULL = (SP == SP_FULL);

    integer i; // For reset initialization
    
    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition
            SP <= SP_EMPTY;
            dataOut <= 4'b0;
            // Clear only valid memory locations
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'b0;
            end
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