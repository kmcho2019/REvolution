module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,         // 0 = push(write), 1 = pop(read)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP;  // Stack pointer: number of entries in stack, 0..4

    integer i;

    // Push and Pop conditions
    wire push = EN && (RW == 1'b0) && (SP < 3'd4); // Can push only if not full
    wire pop  = EN && (RW == 1'b1) && (SP > 3'd0); // Can pop only if not empty

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (push) begin
                // Write dataIn to stack_mem at SP index, then increment SP
                stack_mem[SP] <= dataIn;
                SP <= SP + 3'd1;
            end else if (pop) begin
                // Decrement SP, then read dataOut from stack_mem[SP - 1]
                SP <= SP - 3'd1;
                dataOut <= stack_mem[SP - 3'd1];
            end
        end
        // If EN=0 or no push/pop, hold current values
    end

    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule