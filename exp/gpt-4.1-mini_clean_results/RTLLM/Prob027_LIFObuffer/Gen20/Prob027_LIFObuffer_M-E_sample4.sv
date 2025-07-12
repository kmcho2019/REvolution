module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,       // Active-high synchronous reset
    input  wire        EN,        // Enable signal
    input  wire        RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output wire        EMPTY,
    output wire        FULL
);

    // Stack memory: 4 entries, 4-bit each
    reg [3:0] stack_mem [3:0];

    // Stack pointer counts entries stored: 0 (empty) to 4 (full)
    reg [2:0] SP; // 3 bits to hold 0..4

    // Push operation: EN high, RW=0, not full
    wire push_op = EN && (RW == 1'b0) && (SP != 3'd4);

    // Pop operation: EN high, RW=1, not empty
    wire pop_op  = EN && (RW == 1'b1) && (SP != 3'd0);

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset: clear stack pointer, dataOut, and stack memory
            SP <= 3'd0;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else begin
            if (push_op) begin
                // Push dataIn at stack_mem[SP], then increment SP
                stack_mem[SP] <= dataIn;
                SP <= SP + 3'd1;
            end else if (pop_op) begin
                // Pop: decrement SP, then output data from stack_mem[SP-1]
                SP <= SP - 3'd1;
                dataOut <= stack_mem[SP - 3'd1];
                // Optionally clear popped entry to zero to save power
                stack_mem[SP - 3'd1] <= 4'd0;
            end else begin
                // No change in SP or stack memory if no valid op
                SP <= SP;
                dataOut <= dataOut;
            end
        end
    end

    // Flags combinational from SP
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule