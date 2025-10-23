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

    // Stack memory: 4 entries of 4 bits
    reg [3:0] stack_mem [3:0];

    // Stack pointer: number of elements currently in stack (0 to 4)
    reg [2:0] SP;

    // Combinational enables for push and pop
    wire push_en = EN & (RW == 1'b0) & (SP < 3'd4);
    wire pop_en  = EN & (RW == 1'b1) & (SP > 3'd0);

    // Combinational flags from SP
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    // Temporary variable for pop read address to improve timing
    wire [2:0] pop_read_addr = SP - 3'd1;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            // intentionally do NOT clear stack_mem to reduce reset path and toggle power
        end else begin
            if (push_en) begin
                // Push operation: write input at current SP (next free slot), then increment SP
                stack_mem[SP] <= dataIn;
                SP <= SP + 3'd1;
                // dataOut unchanged on push to reduce toggling
            end else if (pop_en) begin
                // Pop operation: decrement SP first, then update dataOut from memory at new SP
                SP <= SP - 3'd1;
                dataOut <= stack_mem[pop_read_addr];
                // Do not clear stack_mem entry to reduce switching activity
            end
            // else: no operation, maintain SP and dataOut
        end
    end

endmodule