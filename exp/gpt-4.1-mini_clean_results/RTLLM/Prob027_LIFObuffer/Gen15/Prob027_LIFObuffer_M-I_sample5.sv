module LIFObuffer (
    input  wire [3:0] dataIn,
    input  wire       RW,    // 0: write (push), 1: read (pop)
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output reg        EMPTY,
    output reg        FULL,
    output reg  [3:0] dataOut
);

    // Stack memory: 4 entries of 4 bits each
    reg [3:0] stack_mem [3:0];

    // One-hot encoded Stack Pointer: 5 bits [4:0]
    // Bit 4 set means empty stack, bit 0 set means full stack
    reg [4:0] SP;

    // Helper signals
    wire push = EN && (RW == 1'b0) && !FULL;
    wire pop  = EN && (RW == 1'b1) && !EMPTY;

    // Functions to find current top index and next pointer states
    // current top index = position of the lowest '1' bit in SP shifted by 1 to 4 bits
    // Actually, SP bits correspond to count from empty (SP[4]) down to full (SP[0])
    // On push: SP shifts right (toward lower bit)
    // On pop: SP shifts left (toward higher bit)

    integer i;

    // Find top of stack index (0 to 3) for pop dataOut and pop operation
    // The top element is the stack element corresponding to the bit right after the one-hot '1' in SP.
    // Since SP=empty means SP[4]=1, so top element is at SP_bit_pos - 1
    // For example, SP=5'b10000 (empty), top index invalid (no data)
    // If SP=5'b01000 (index=3 empty from top), top element index=3
    // If SP=5'b00100 -> top element index=2, etc.

    // We'll create a function to convert SP to top index
    function [2:0] top_index;
        input [4:0] sp_in;
        integer idx;
        begin
            top_index = 3'd0; // default 0
            for (idx=0; idx<5; idx=idx+1) begin
                if (sp_in[idx]) begin
                    // The element on top of stack is idx-1 (if idx>0)
                    // If idx==4 (empty), no data
                    if (idx == 4)
                        top_index = 3'd0; // invalid but won't be used when empty
                    else
                        top_index = idx[2:0] - 1;
                    disable for;
                end
            end
        end
    endfunction

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 5'b10000;   // empty: only bit 4 set
            dataOut <= 4'd0;
            EMPTY <= 1'b1;
            FULL  <= 1'b0;
            // Do not clear stack_mem to save area and reset time
        end else begin
            if (push && !pop) begin
                // Push: shift SP right by one bit
                // Before push, SP must not be full (bit0==0)
                SP <= SP >> 1;
                // Write data to new top entry = position of new SP bit + 1
                // Since SP shifted right, the new top is position of the '1' in SP after shift + 0
                // The new SP bit position = pos of '1' in SP after shift

                // Find index of SP after shift (which is SP>>1)
                // Since we just assigned SP <= SP >> 1, the new SP is SP >> 1
                // We must write to memory at new top = top_index(SP >> 1)
                // top_index gives idx of stack_mem to write

                // We'll evaluate top_index on SP >> 1 to get index for data write
                // Because this is sequential logic, we can calculate index in a temporary reg

                // For clarity, calculate top_index in a local variable:
                // Since indexing needs combinational for memory write, we'll replicate the calculation here.

                // See below to address combinational memory write in sequential block.

                // To address synthesis tool requirements:
                // We can create a separate variable 'new_SP' and 'write_index' for the assignment below

            end else if (pop && !push) begin
                // Pop: shift SP left by one bit (toward empty)
                // Before pop, SP must not be empty (bit4==0)
                // Read dataOut from current top index first, then update SP

                // dataOut is assigned below after calculation

                SP <= SP << 1;
            end
            // If both push and pop at once or none, no state change, hold values
            else if (push && pop) begin
                // When push and pop occur simultaneously, pointer remains unchanged,
                // dataOut updates with popped data, and stack_mem updates with push data

                // Assign SP unchanged

                // We'll handle data write and read below
            end
        end
    end

    // To handle data writes and reads correctly in sync with SP,
    // separate always block with combinational logic for indexing

    reg [2:0] write_index;
    reg [2:0] read_index;
    reg [4:0] next_SP_push;
    reg [4:0] next_SP_pop;
    reg [4:0] next_SP;

    always @(*) begin
        write_index = 3'd0;
        read_index = 3'd0;
        next_SP_push = SP >> 1;
        next_SP_pop  = SP << 1;
        next_SP = SP;

        // Compute write index for push operation
        // top_index(next_SP_push)
        // Find pos of 1 in next_SP_push, index is bit position - 1

        // Function inline equivalent:
        integer idx;
        write_index = 3'd0;
        for (idx=0; idx<5; idx=idx+1) begin
            if (next_SP_push[idx]) begin
                if (idx == 4)
                    write_index = 3'd0;
                else
                    write_index = idx - 1;
                disable for;
            end
        end

        // Compute read index for pop operation
        // top_index(SP)
        read_index = 3'd0;
        for (idx=0; idx<5; idx=idx+1) begin
            if (SP[idx]) begin
                if (idx == 4)
                    read_index = 3'd0;
                else
                    read_index = idx -1;
                disable for;
            end
        end
    end

    always @(posedge Clk) begin
        if (!Rst) begin
            if (push && !pop) begin
                // Write dataIn to stack_mem at write_index
                stack_mem[write_index] <= dataIn;
                dataOut <= dataOut;  // hold
                EMPTY <= 1'b0;
                if (next_SP_push == 5'b00001)
                    FULL <= 1'b1;
                else
                    FULL <= 1'b0;
            end else if (pop && !push) begin
                // Read dataOut from stack_mem at read_index
                dataOut <= stack_mem[read_index];
                EMPTY <= (next_SP_pop == 5'b10000);
                FULL  <= 1'b0;
            end else if (push && pop) begin
                // Simultaneous push and pop
                // Write dataIn at write_index (same SP after no change)
                stack_mem[write_index] <= dataIn;
                // Read dataOut from read_index before pointer change (pointer unchanged)
                dataOut <= stack_mem[read_index];
                EMPTY <= EMPTY;
                FULL  <= FULL;
            end else begin
                // No operation
                dataOut <= dataOut; // hold
                EMPTY <= EMPTY;
                FULL  <= FULL;
            end
        end
    end

endmodule