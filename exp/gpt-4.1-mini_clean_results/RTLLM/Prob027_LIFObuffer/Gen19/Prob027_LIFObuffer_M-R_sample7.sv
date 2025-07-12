module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,       // Active-high synchronous reset
    input  wire        EN,        // Enable signal
    input  wire        RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    // Stack memory: 4 entries, 4-bit each
    reg [3:0] stack_mem [3:0];

    // Stack Pointer (SP):
    // Counts from 0 (empty) to 4 (full)
    // push: store at stack_mem[SP], then SP increments
    // pop : SP decrements, then output stack_mem[SP-1]
    reg [2:0] SP; // can count 0..4, requires 3 bits

    // Combinational signals for next state
    reg [2:0] next_SP;
    reg [3:0] dataOut_next;
    reg push_enable;
    reg pop_enable;

    integer i;

    // Combinational logic: decide push/pop enables and next_SP
    always @(*) begin
        push_enable = EN && (RW == 1'b0) && (SP < 3'd4);  // Can push if not full
        pop_enable  = EN && (RW == 1'b1) && (SP > 3'd0);  // Can pop if not empty

        // Default assignments
        next_SP = SP;
        dataOut_next = dataOut;

        if (push_enable && !pop_enable) begin
            // Push operation: increment SP after push
            next_SP = SP + 3'd1;
        end else if (!push_enable && pop_enable) begin
            // Pop operation: decrement SP before pop
            next_SP = SP - 3'd1;
            // dataOut_next updated in sequential block after decrement
        end else if (push_enable && pop_enable) begin
            // Both push and pop at the same clock (if allowed) - stack size unchanged
            // DataOut updated from top after pop
            // For LIFO, consider pop then push (or vice versa)
            // Here, assume pop then push: SP decrements then increments back to same
            next_SP = SP;
        end
        // else: no operation, hold SP and dataOut
    end

    // Sequential logic: update SP, stack_mem, dataOut on clock edge
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;       // Empty stack
            dataOut <= 4'd0;
            // Clear stack memory
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else begin
            // Update stack pointer
            SP <= next_SP;

            if (push_enable && !pop_enable) begin
                // Push operation: write dataIn to current SP location (before increment)
                stack_mem[SP] <= dataIn;
            end else if (!push_enable && pop_enable) begin
                // Pop operation: output top of stack (SP-1 after decrement)
                dataOut <= stack_mem[SP - 3'd1];
                // Optional: do not clear memory location to save toggling
            end else if (push_enable && pop_enable) begin
                // Push and pop together:
                // Effectively stack size unchanged, but top data changes
                // Pop: dataOut updated with top before push
                dataOut <= stack_mem[SP - 3'd1];
                // Push new data at same location after pop
                stack_mem[SP - 3'd1] <= dataIn;
            end
            // else no operation: hold dataOut and stack_mem
        end
    end

    // Flags: EMPTY when SP==0; FULL when SP==4
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule