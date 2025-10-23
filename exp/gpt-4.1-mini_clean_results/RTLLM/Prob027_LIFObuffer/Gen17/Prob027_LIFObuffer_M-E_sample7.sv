module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,       // Active high synchronous reset
    input  wire        EN,        // Enable signal
    input  wire        RW,        // Read/Write control: 0 = push, 1 = pop
    input  wire [3:0]  dataIn,    // Data input for push
    output wire        EMPTY,     // High when buffer is empty
    output wire        FULL,      // High when buffer is full
    output reg  [3:0]  dataOut    // Data output for pop
);

    // Stack memory: 4 entries of 4 bits
    reg [3:0] stack_mem [3:0];

    // One-hot encoded stack pointer (5 bits):
    // bit[4] = empty (no elements),
    // bits[3:0] = top-of-stack position (bit set indicates stack depth)
    reg [4:0] SP_onehot;

    // Helper signals for full and empty detection:
    // EMPTY when SP_onehot == 5'b1_0000 (bit 4 set)
    // FULL when SP_onehot[3:0] == 4'b1111 (all bottom 4 bits set)
    // Actually, in this design, since it's one-hot pointer, FULL means bit0 set (full stack)
    // But we need to define a scheme:
    // Let's define SP_onehot as indicating next free position:
    // SP_onehot[4] = all empty (ptr=4)
    // SP_onehot[3] = next free position 3 (meaning 1 element at position 3)
    // SP_onehot[0] = next free position 0 (meaning 4 elements occupied)
    // So FULL when SP_onehot == 5'b00001 (bit0 set)
    // EMPTY when SP_onehot == 5'b10000 (bit4 set)

    // So push moves pointer right shift by 1 (towards bit0), pop moves left shift by 1 (towards bit4)

    wire empty_flag = (SP_onehot == 5'b10000);
    wire full_flag  = (SP_onehot == 5'b00001);

    assign EMPTY = empty_flag;
    assign FULL  = full_flag;

    // Calculate push and pop enable signals gated by EN and full/empty status
    wire push_en = EN && (RW == 1'b0) && (!full_flag);
    wire pop_en  = EN && (RW == 1'b1) && (!empty_flag);

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset pointer to empty (bit 4 set), clear stack memory and dataOut
            SP_onehot <= 5'b10000;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else begin
            if (push_en) begin
                // Determine index to write: next free position is the bit set in SP_onehot shifted right by 1
                // Find current pointer index (bit set in SP_onehot)
                // For example, if SP_onehot=10000 (bit4), then push writes to position 4-1=3
                // So calculate index as: index = pos_of_bit(SP_onehot) - 1

                // Because SP_onehot always has exactly one bit set, we can find it by priority encoding
                // Instead of complex priority logic in always block, precompute index combinationally:

                // Find position of SP_onehot (0 to 4)
                // This can be done via case or arithmetic:

                case (SP_onehot)
                    5'b10000: stack_mem[3] <= dataIn; // pointer at 4 means write at pos 3
                    5'b01000: stack_mem[2] <= dataIn;
                    5'b00100: stack_mem[1] <= dataIn;
                    5'b00010: stack_mem[0] <= dataIn;
                    default: ; // Should not happen on push if not full
                endcase

                // Update pointer: shift right by 1 to indicate one more element added (pointer moves towards bit0)
                SP_onehot <= SP_onehot >> 1;
            end else if (pop_en) begin
                // Pop operation: output data at position one less than pointer position
                // Since pointer points to next free slot, top element is at pointer pos + 1

                // For example, SP_onehot=01000 (bit3) means top element at 3 (stack_mem[3]) was just popped

                // Compute index of top element: position of bit set in SP_onehot + 1

                case (SP_onehot)
                    5'b01000: dataOut <= stack_mem[3];
                    5'b00100: dataOut <= stack_mem[2];
                    5'b00010: dataOut <= stack_mem[1];
                    5'b00001: dataOut <= stack_mem[0];
                    5'b10000: dataOut <= 4'd0; // empty case (should not pop)
                    default: dataOut <= 4'd0; // Safety default
                endcase

                // Update pointer: shift left by 1 to indicate one less element in stack (pointer moves towards bit4)
                SP_onehot <= SP_onehot << 1;
            end else begin
                // No operation, retain pointer and output dataOut as is
                dataOut <= dataOut;
                SP_onehot <= SP_onehot;
            end
        end
    end

endmodule