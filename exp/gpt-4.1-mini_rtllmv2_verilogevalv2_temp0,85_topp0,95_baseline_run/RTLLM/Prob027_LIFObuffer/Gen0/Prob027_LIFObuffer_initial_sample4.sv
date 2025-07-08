module LIFObuffer(
    input      [3:0] dataIn,
    input            RW,
    input            EN,
    input            Rst,
    input            Clk,
    output reg       EMPTY,
    output reg       FULL,
    output reg [3:0] dataOut
);

    reg [3:0] stack_mem [3:0]; // 4 entries, 4-bit each
    reg [2:0] SP;              // 3 bits to hold 0 to 4 (4 means empty)

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset: clear stack, set SP to 4 (empty)
            SP <= 3'd4;
            dataOut <= 4'b0;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'b0;
            end
        end else if (EN) begin
            // Push operation: RW = 0, if not full
            if (RW == 1'b0 && FULL == 1'b0) begin
                // Decrement SP and store data
                SP <= SP - 1;
                stack_mem[SP - 1] <= dataIn;
                dataOut <= 4'b0; // clear output on write
            end
            // Pop operation: RW = 1, if not empty
            else if (RW == 1'b1 && EMPTY == 1'b0) begin
                // Output top element and increment SP
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= 4'b0;
                SP <= SP + 1;
            end
            // Otherwise no change
        end else begin
            // If EN is low, maintain current dataOut and SP
            dataOut <= dataOut;
            SP <= SP;
        end

        // Update EMPTY and FULL flags after SP changes
        EMPTY <= (SP == 3'd4);
        FULL  <= (SP == 3'd0);
    end

endmodule