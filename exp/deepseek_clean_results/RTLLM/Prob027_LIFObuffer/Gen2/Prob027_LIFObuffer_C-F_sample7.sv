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

    reg [3:0] stack_mem [0:3];
    reg [1:0] SP;          // Main stack pointer (0-3)
    reg SP_empty;          // Special flag for empty state (SP=4)

    always @(posedge Clk) begin
        if (Rst) begin
            // Minimal reset: only initialize control signals
            SP <= 2'b0;
            SP_empty <= 1'b1;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[SP] <= dataIn;
                if (SP_empty) begin
                    SP_empty <= 1'b0;
                    SP <= 2'b11;  // Start from top when empty
                end else begin
                    SP <= SP - 1;
                end
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                if (!SP_empty) begin
                    dataOut <= stack_mem[SP + 1];
                end else begin
                    dataOut <= stack_mem[0];
                end
                
                if (SP == 2'b11) begin
                    SP_empty <= 1'b1;
                end else begin
                    SP <= SP + 1;
                end
            end
            
            // Update flags (combinatorial-style but registered)
            EMPTY <= SP_empty;
            FULL <= (!SP_empty && (SP == 2'b00));
        end
    end

endmodule