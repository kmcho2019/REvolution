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

    // Stack memory: 4 entries x 4 bits
    reg [3:0] stack_mem [0:3];

    // Stack pointer: number of elements in the stack (0 to 4)
    reg [2:0] SP;

    // Combinational flags
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    // Internal enables for push and pop
    wire push_en = EN && (RW == 1'b0) && (~FULL);
    wire pop_en  = EN && (RW == 1'b1) && (~EMPTY);

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else begin
            if (push_en) begin
                // Write data at current SP, then increment SP
                stack_mem[SP] <= dataIn;
                SP <= SP + 1;
                // dataOut unchanged on push
            end else if (pop_en) begin
                // Decrement SP first, then output data at SP-1
                SP <= SP - 1;
                dataOut <= stack_mem[SP - 1];
                // memory not cleared to reduce switching
            end
            // Else no operation: hold SP and dataOut
        end
    end

endmodule