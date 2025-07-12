module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,        // Active-high synchronous reset
    input  wire        EN,         // Enable signal
    input  wire        RW,         // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output wire        EMPTY,
    output wire        FULL
);

    // Stack memory: 4 entries, 4-bit each
    reg [3:0] stack_mem [3:0];

    // Stack Pointer (SP): counts entries in stack (0 to 4)
    // SP = number of valid entries in stack_mem
    reg [2:0] SP;

    // Flags combinational
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    // Signals for push and pop operations gated by EN and buffer state
    wire push_op = EN && (RW == 1'b0) && (SP != 3'd4); // can push if not full
    wire pop_op  = EN && (RW == 1'b1) && (SP != 3'd0); // can pop if not empty

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // On reset, clear stack memory, set SP to 0 (empty), clear dataOut
            SP <= 3'd0;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else begin
            if (push_op) begin
                // Write dataIn into stack_mem at position SP (top)
                stack_mem[SP] <= dataIn;
                SP <= SP + 3'd1;
                // dataOut unchanged on push
            end else if (pop_op) begin
                // Pop operation: decrement SP, output data from stack_mem[SP - 1]
                SP <= SP - 3'd1;
                dataOut <= stack_mem[SP - 3'd1];
                // Do NOT clear stack_mem at popped position for power saving
            end
            // If no push or pop, hold all registers
        end
    end

endmodule