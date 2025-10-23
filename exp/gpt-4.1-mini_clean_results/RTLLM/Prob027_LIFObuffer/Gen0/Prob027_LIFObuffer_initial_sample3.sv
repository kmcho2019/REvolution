module LIFObuffer (
    input  wire [3:0] dataIn,
    input  wire       RW,
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output reg        EMPTY,
    output reg        FULL,
    output reg  [3:0] dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // Stack pointer: 4 means empty (points beyond top)

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;
            dataOut <= 4'b0000;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'b0000;
            end
        end else if (EN) begin
            // Push operation: RW=0
            if (RW == 1'b0) begin
                if (SP != 0) begin
                    SP <= SP - 1;
                    stack_mem[SP - 1] <= dataIn;
                    EMPTY <= 1'b0;
                    if ((SP - 1) == 0)
                        FULL <= 1'b1;
                    else
                        FULL <= 1'b0;
                end
                // else full, no operation
            end else begin
                // Pop operation: RW=1
                if (SP != 4) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'b0000;
                    SP <= SP + 1;
                    FULL <= 1'b0;
                    if ((SP + 1) == 4)
                        EMPTY <= 1'b1;
                    else
                        EMPTY <= 1'b0;
                end else begin
                    // empty, no operation, dataOut unchanged
                end
            end
        end
    end

endmodule