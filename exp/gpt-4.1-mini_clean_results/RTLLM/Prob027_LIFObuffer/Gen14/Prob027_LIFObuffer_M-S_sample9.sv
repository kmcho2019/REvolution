module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,
    input  wire       EN,
    input  wire       RW,           // 0: write (push), 1: read (pop)
    input  wire [3:0] dataIn,
    output reg  [3:0] dataOut,
    output wire       EMPTY,
    output wire       FULL
);

    reg [3:0] stack_mem [3:0];  // 4 x 4-bit stack entries
    reg [2:0] SP;               // Stack pointer: points to next free slot (0 to 4)

    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    integer i;
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            // No need to clear entire stack_mem to simplify design
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation
                if (SP < 3'd4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
            end else begin
                // Pop operation
                if (SP > 3'd0) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                end
            end
        end
    end

endmodule