module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output wire        EMPTY,
    output wire        FULL
);

    // Stack memory: 4 entries of 4-bit data
    reg [3:0] stack_mem [3:0];

    // Stack pointer: number of elements currently in stack (0 to 4)
    reg [2:0] SP;

    // Push and pop enable signals
    wire push_en = EN && (RW == 1'b0) && (SP < 3'd4);
    wire pop_en  = EN && (RW == 1'b1) && (SP > 3'd0);

    // Flags combinationally assigned from SP
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;      // empty stack
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (push_en) begin
                stack_mem[SP] <= dataIn; // write input at current SP (next free slot)
                SP <= SP + 1;            // increment pointer
                // dataOut remains unchanged on push
            end else if (pop_en) begin
                SP <= SP - 1;            // decrement pointer first
                dataOut <= stack_mem[SP - 1]; // output popped data
                // Not clearing stack_mem location on pop to reduce toggling
            end
            // If no push or pop, hold SP and dataOut
        end
        // If EN is low, hold SP and dataOut
    end

endmodule