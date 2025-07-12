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

    // Parameters
    localparam DEPTH = 4;
    localparam PTR_WIDTH = 3;  // Enough to count to DEPTH (4)

    // Stack memory: 4 entries, 4-bit each
    reg [3:0] stack_mem [DEPTH-1:0];

    // Stack Pointer (SP):
    // SP counts from 0 (empty) up to DEPTH (full).
    // push: write at SP, then increment SP
    // pop : decrement SP, then read at SP
    reg [PTR_WIDTH-1:0] SP;

    // Operation signals
    wire push_op = EN && (RW == 1'b0) && (SP != DEPTH);    // push if not full
    wire pop_op  = EN && (RW == 1'b1) && (SP != 0);        // pop if not empty

    // Next SP calculation
    wire [PTR_WIDTH-1:0] next_SP = (push_op) ? (SP + 1) :
                                  (pop_op)  ? (SP - 1) :
                                             SP;

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 0;
            dataOut <= 4'd0;
            for (i = 0; i < DEPTH; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else begin
            SP <= next_SP;

            // Push operation: write dataIn at SP before incrementing
            if (push_op) begin
                stack_mem[SP] <= dataIn;
            end

            // Pop operation: decrement SP, then output the data at new SP
            if (pop_op) begin
                dataOut <= stack_mem[next_SP];
                // Do not clear popped location to reduce toggling
            end
        end
    end

    // Flags combinational from SP
    assign EMPTY = (SP == 0);
    assign FULL  = (SP == DEPTH);

endmodule