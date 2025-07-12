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
    reg [2:0] SP; // Stack pointer: 0 to 4 (0 empty, 4 full)

    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0 && !FULL) begin
                // Push operation
                stack_mem[SP] <= dataIn;
                SP <= SP + 1;
            end else if (RW == 1'b1 && !EMPTY) begin
                // Pop operation
                SP <= SP - 1;
                dataOut <= stack_mem[SP - 1];
            end
        end
    end

endmodule