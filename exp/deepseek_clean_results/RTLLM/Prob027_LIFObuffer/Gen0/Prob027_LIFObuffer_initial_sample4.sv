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

    // Internal memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (0-4)
    reg [2:0] SP;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset operation
            SP <= 3'd4;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
            // Clear stack memory
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
                stack_mem[SP] <= 4'b0;  // Clear popped location
                SP <= SP + 1;
            end
        end

        // Update flags
        EMPTY <= (SP == 3'd4);
        FULL <= (SP == 3'd0);
    end

endmodule