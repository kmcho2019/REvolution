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

    // Stack memory: 4 entries of 4 bits each
    reg [3:0] stack_mem [3:0];

    // Stack Pointer: 0 = empty, 4 = full
    reg [2:0] SP;

    // Flags
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    // Internal signals to gate operations
    wire push_enable = EN && (RW == 1'b0) && !FULL;
    wire pop_enable  = EN && (RW == 1'b1) && !EMPTY;

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;       // Empty buffer
            dataOut <= 4'd0;
            // Optional: clear memory for debug visibility
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else begin
            if (push_enable) begin
                // Write dataIn at current SP position, then increment SP
                stack_mem[SP] <= dataIn;
                SP <= SP + 1;
            end else if (pop_enable) begin
                // Decrement SP, then output data from new top
                SP <= SP - 1;
                dataOut <= stack_mem[SP - 1];
                // Optional: clear popped location to reduce data retention glitches
                stack_mem[SP - 1] <= 4'd0;
            end
            // else: hold SP and dataOut
        end
    end

endmodule