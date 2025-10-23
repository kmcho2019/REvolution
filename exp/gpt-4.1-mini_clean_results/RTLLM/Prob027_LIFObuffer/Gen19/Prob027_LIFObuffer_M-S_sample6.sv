module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    reg [3:0] stack_mem [0:3];
    reg [2:0] SP;  // 3-bit stack pointer: 4 = empty, 0 = full

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;       // stack empty
            dataOut <= 4'd0;
            // Clear entire stack on reset
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else if (EN) begin
            if ((RW == 1'b0) && (SP != 3'd0)) begin
                // push operation: decrement SP, write dataIn
                SP <= SP - 3'd1;
                stack_mem[SP - 3'd1] <= dataIn;
            end else if ((RW == 1'b1) && (SP != 3'd4)) begin
                // pop operation: read dataOut, clear location, increment SP
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= 4'd0;
                SP <= SP + 3'd1;
            end
            // else: no operation, maintain SP and dataOut
        end
    end

    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule