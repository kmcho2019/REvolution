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

    // Stack memory (4 entries, each 4 bits)
    reg [3:0] stack_mem [0:3];
    
    // Stack pointer (4 means empty, 0 means full)
    reg [2:0] SP;

    integer i; // For initialization loop

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition: clear stack and set SP to empty
            SP <= 3'd4;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'b0;
            end
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[SP-1] <= dataIn;
                SP <= SP - 1;
                EMPTY <= 1'b0;
                FULL <= (SP == 3'd1);
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= stack_mem[SP];
                SP <= SP + 1;
                FULL <= 1'b0;
                EMPTY <= (SP == 3'd3);
            end
        end
    end

    // Alternative flag logic (combinational version if preferred)
    // assign EMPTY = (SP == 3'd4);
    // assign FULL = (SP == 3'd0);

endmodule