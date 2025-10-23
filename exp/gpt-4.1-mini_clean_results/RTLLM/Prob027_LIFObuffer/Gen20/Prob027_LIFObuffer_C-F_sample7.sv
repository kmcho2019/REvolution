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

    // Stack memory: 4 entries of 4 bits each
    reg [3:0] stack_mem [3:0];

    // Stack Pointer (SP):
    // Counts down from 4 (empty) to 0 (full)
    // Push: SP decremented by 1, data written at SP - 1
    // Pop: dataOut loaded from stack_mem[SP], then SP incremented by 1
    reg [2:0] SP; // valid range: 0 to 4

    // Push and Pop enable signals
    wire push_en = EN && (RW == 1'b0) && (SP != 3'd0);   // Push if not full
    wire pop_en  = EN && (RW == 1'b1) && (SP != 3'd4);   // Pop if not empty

    // Next stack pointer value
    wire [2:0] next_SP = push_en ? (SP - 3'd1) :
                         pop_en  ? (SP + 3'd1) :
                                   SP;

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Synchronous reset: clear SP, dataOut, and stack memory
            SP <= 3'd4;          // Stack empty
            dataOut <= 4'd0;     // Clear output data
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else if (push_en || pop_en) begin
            // Update stack pointer
            SP <= next_SP;

            if (push_en) begin
                // Push operation: write dataIn at SP - 1 (new top)
                stack_mem[SP - 3'd1] <= dataIn;
                // dataOut remains unchanged on push
            end else if (pop_en) begin
                // Pop operation: read dataOut from stack_mem[SP]
                dataOut <= stack_mem[SP];
                // Do not clear stack_mem[SP] to save power
            end
        end
        // If no valid push/pop operation or EN is low, hold all registers
    end

    // Flags derived combinationally from SP
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule