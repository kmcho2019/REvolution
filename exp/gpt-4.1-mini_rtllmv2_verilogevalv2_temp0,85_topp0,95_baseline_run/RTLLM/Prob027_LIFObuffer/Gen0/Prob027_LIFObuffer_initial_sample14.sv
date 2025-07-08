module LIFObuffer (
    input       [3:0] dataIn,
    input             RW,    // 1 = read, 0 = write
    input             EN,
    input             Rst,
    input             Clk,
    output reg        EMPTY,
    output reg        FULL,
    output reg [3:0]  dataOut
);

    // Stack memory: 4 entries, each 4 bits
    reg [3:0] stack_mem [3:0];
    // Stack Pointer (points to next free position from top)
    // SP = 4 means empty, SP = 0 means full
    reg [2:0] SP;

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset: clear memory and set SP to empty
            SP <= 4;
            dataOut <= 4'b0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'b0;
            end
            EMPTY <= 1;
            FULL <= 0;
        end else if (EN) begin
            if (RW == 0) begin
                // Write operation: push data if not full
                if (SP != 0) begin
                    SP <= SP - 1;
                    stack_mem[SP - 1] <= dataIn;
                    dataOut <= dataOut; // hold previous output
                end
            end else begin
                // Read operation: pop data if not empty
                if (SP != 4) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'b0;
                    SP <= SP + 1;
                end else begin
                    dataOut <= dataOut; // hold previous output
                end
            end

            // Update flags
            EMPTY <= (SP == 4);
            FULL <= (SP == 0);
        end
    end

endmodule