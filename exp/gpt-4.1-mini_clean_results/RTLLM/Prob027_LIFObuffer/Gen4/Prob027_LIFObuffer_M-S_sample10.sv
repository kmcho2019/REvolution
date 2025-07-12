module LIFObuffer (
    input  wire [3:0] dataIn,
    input  wire       RW,    // 0: write (push), 1: read (pop)
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output wire       EMPTY,
    output wire       FULL,
    output reg  [3:0] dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP;  // 0..4; 4 means empty

    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;
            dataOut <= 4'd0;
            // stack_mem contents are don't-care after reset (no explicit clear)
        end else if (EN) begin
            if (RW == 1'b0 && !FULL) begin
                // Push operation: decrement SP, write dataIn
                SP <= SP - 1;
                stack_mem[SP - 1] <= dataIn;
            end else if (RW == 1'b1 && !EMPTY) begin
                // Pop operation: read dataOut, increment SP
                dataOut <= stack_mem[SP];
                SP <= SP + 1;
            end
        end
    end

endmodule