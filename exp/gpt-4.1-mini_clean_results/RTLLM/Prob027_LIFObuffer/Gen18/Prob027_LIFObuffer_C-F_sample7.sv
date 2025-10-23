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

    // Stack memory: 4 entries, each 4 bits wide
    reg [3:0] stack_mem [3:0];

    // Stack Pointer (SP):
    // Counts number of valid entries in stack:
    // 0 = empty, 4 = full
    reg [2:0] SP; // range 0..4

    // Conditions for push and pop operations
    wire push_op = EN && (RW == 1'b0) && (SP < 3'd4);
    wire pop_op  = EN && (RW == 1'b1) && (SP > 3'd0);

    // EMPTY when SP is zero entries
    assign EMPTY = (SP == 3'd0);
    // FULL when SP has 4 entries
    assign FULL  = (SP == 3'd4);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;          // Initialize stack pointer to empty
            dataOut <= 4'd0;     // Clear output register
            // Do not clear stack_mem to save area and power; not functionally required
        end else begin
            if (push_op) begin
                // Push operation: write dataIn at SP and increment SP
                stack_mem[SP] <= dataIn;
                SP <= SP + 3'd1;
            end else if (pop_op) begin
                // Pop operation: decrement SP, then output the popped data
                SP <= SP - 3'd1;
                dataOut <= stack_mem[SP - 3'd1];
                // Do not clear stack_mem entry to reduce toggling
            end
            // If EN low or invalid operation, hold current state
        end
    end

endmodule