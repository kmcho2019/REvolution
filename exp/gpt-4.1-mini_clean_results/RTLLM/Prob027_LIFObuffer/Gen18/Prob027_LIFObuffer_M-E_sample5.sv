module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,       // Active-high synchronous reset
    input  wire        EN,        // Enable signal
    input  wire        RW,        // 0=write(push), 1=read(pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output wire        EMPTY,
    output wire        FULL
);

    // Stack memory: 4 entries x 4-bit
    reg [3:0] stack_mem [3:0];

    // One-hot encoded Stack Pointer (SP):
    // SP[4] = 1 means empty
    // SP shifts right to push (moving top down)
    // SP shifts left to pop (moving top up)
    reg [4:0] SP;

    integer i;

    wire push_op = EN && (RW == 1'b0) && (FULL == 1'b0);
    wire pop_op  = EN && (RW == 1'b1) && (EMPTY == 1'b0);
    wire valid_op = push_op || pop_op;

    // Find current top index (0 to 3) by decoding SP one-hot bits 0..3
    // SP[0]..SP[3] corresponds to valid data locations; SP[4] = empty flag bit
    // Since SP is one-hot, only one bit high
    // The top index for push (write) is one less than current top for push (shifting right)
    // For pop, output data from current top (where SP has a 1 in bits[0..3])

    // Data index for pop: index of '1' in bits[0..3]
    // We can encode by priority encoder style
    wire [2:0] top_index_pop = 
        SP[0] ? 3'd0 :
        SP[1] ? 3'd1 :
        SP[2] ? 3'd2 :
        SP[3] ? 3'd3 :
        3'dx; // x if empty (SP[4])

    // Data index for push: one below current top (SP shifts right)
    // For push, new top is current top index - 1, but using one-hot shift right
    // So new top position = (current SP) >> 1 (logical right shift)
    // If current SP = 5'b10000 (empty), shifting right = 5'b01000 (top at 3)
    // So push onto position top_index_push = position of new SP one-hot bit in [0..3]
    // Here, next_SP will be SP>>1

    reg [4:0] next_SP;

    always @(*) begin
        if (Rst)
            next_SP = 5'b10000; // empty
        else if (push_op)
            next_SP = SP >> 1;  // shift right: push moves top down
        else if (pop_op)
            next_SP = SP << 1;  // shift left: pop moves top up
        else
            next_SP = SP;
    end

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 5'b10000;      // empty
            dataOut <= 4'd0;
            // Clear memory
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else if (valid_op) begin
            SP <= next_SP;

            if (push_op) begin
                // Write dataIn to new top index = index of next_SP after shift right
                // next_SP = SP >> 1, so new top bit position is one right shift from old SP
                // Find index where next_SP has '1' in bits[0..3]
                // next_SP[4] = possibly 0 or 1 (should never push if full, so next_SP != 0)
                // We'll do a priority encoder over next_SP[0..3]
                integer push_index;
                push_index = (next_SP[0] ? 0 :
                              next_SP[1] ? 1 :
                              next_SP[2] ? 2 :
                              next_SP[3] ? 3 : -1);
                if (push_index >= 0)
                    stack_mem[push_index] <= dataIn;
                // dataOut unchanged on push
            end else if (pop_op) begin
                // Output data from current top index (before SP changes)
                if (top_index_pop <= 3)
                    dataOut <= stack_mem[top_index_pop];
                else
                    dataOut <= 4'd0; // Safety default if empty (should not happen)
                // No clearing of stack_mem on pop for power saving
            end
            // else no change
        end
        // else hold current values
    end

    assign EMPTY = (SP == 5'b10000);
    assign FULL  = (SP[0] == 1'b1);

endmodule