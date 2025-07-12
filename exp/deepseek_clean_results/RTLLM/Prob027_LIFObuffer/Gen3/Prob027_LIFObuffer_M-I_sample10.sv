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
    
    // Stack pointer (4 means empty, 0 means full)
    reg [2:0] SP;
    
    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition - only initialize essential elements
            SP <= 3'd4;          // Set stack pointer to empty
            EMPTY <= 1'b1;       // Set empty flag
            FULL <= 1'b0;        // Clear full flag
            dataOut <= 4'b0;      // Clear output
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push) when not full
                stack_mem[SP-1] <= dataIn;  // Store data
                SP <= SP - 1;               // Decrement stack pointer
                
                // Update flags - simplified logic
                EMPTY <= 1'b0;
                FULL <= (SP == 3'd1);
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop) when not empty
                dataOut <= stack_mem[SP];  // Output data
                SP <= SP + 1;            // Increment stack pointer
                
                // Update flags - simplified logic
                FULL <= 1'b0;
                EMPTY <= (SP == 3'd3);
            end
        end
    end
    
    // Combinational flag updates for better timing
    always @(*) begin
        EMPTY = (SP == 3'd4);
        FULL = (SP == 3'd0);
    end
    
endmodule