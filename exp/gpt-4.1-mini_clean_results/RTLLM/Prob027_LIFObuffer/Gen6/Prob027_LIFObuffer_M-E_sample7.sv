module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,
    input  wire       EN,
    input  wire       RW,        // 0: write (push), 1: read (pop)
    input  wire [3:0] dataIn,
    output reg  [3:0] dataOut,
    output wire       EMPTY,
    output wire       FULL
);

    // Stack memory: 4 words of 4 bits
    reg [3:0] stack_mem [3:0];
    reg [2:0] SP;  // Stack Pointer, points to next free slot; 0 to 4

    // Combinational flags
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

    integer i;

    always @(posedge Clk or posedge Rst) begin
        if (Rst) begin
            // On reset, clear stack and set SP to 4 (empty)
            SP <= 3'd4;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation
                if (!FULL) begin
                    // Decrement SP and store dataIn at stack_mem[SP-1]
                    SP <= SP - 1;
                    stack_mem[SP - 1] <= dataIn;
                    // dataOut unchanged during push
                end
            end else begin
                // Pop operation
                if (!EMPTY) begin
                    // Read dataOut from current SP location
                    dataOut <= stack_mem[SP];
                    // Clear popped location (optional)
                    stack_mem[SP] <= 4'd0;
                    // Increment SP to remove the top element
                    SP <= SP + 1;
                end else begin
                    // If empty, keep dataOut unchanged
                    dataOut <= dataOut;
                end
            end
        end
    end

endmodule