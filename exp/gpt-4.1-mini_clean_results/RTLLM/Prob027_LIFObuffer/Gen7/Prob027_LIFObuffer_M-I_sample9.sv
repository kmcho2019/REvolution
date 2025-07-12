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

    // 1-hot stack pointer encoding: 
    // 4'b1000 means empty (SP at 4),
    // 4'b0001 means full (SP at 0)
    reg [3:0] SP_1hot;

    // Combinational signals
    wire empty = (SP_1hot == 4'b1000);
    wire full  = (SP_1hot == 4'b0001);

    assign EMPTY = empty;
    assign FULL  = full;

    // Find current top index for pop:
    // When popping, data is at the position of '1' in SP_1hot shifted right by 1 (MSB side),
    // But since SP_1hot has one bit at position SP,
    // the top data is at the position next to the bit set in SP_1hot shifted right by 1
    // To simplify, keep SP_1hot representing the next free position (like an empty pointer),
    // so top data is at SP_1hot shifted right by 1.
    // For push, write to position SP pointer - 1 (lowest zero bit)

    // We'll implement:
    // SP_1hot encodes next free index (empty slot index):
    //   '1000' = 4 means empty (all empty)
    //   '0001' = 0 means full (no empty slots)
    // Push: shift left (decrement index)
    // Pop:  shift right (increment index)
    // For data:
    //   On push, write to SP_1hot << 1 (one less than current SP)
    //   On pop, read from SP_1hot (current SP) index

    // Function to get index from 1-hot pointer (position of '1')
    function [1:0] onehot_to_idx;
        input [3:0] v;
        begin
            casez (v)
                4'b0001: onehot_to_idx = 2'd0;
                4'b0010: onehot_to_idx = 2'd1;
                4'b0100: onehot_to_idx = 2'd2;
                4'b1000: onehot_to_idx = 2'd3;
                default: onehot_to_idx = 2'd0; // default safe
            endcase
        end
    endfunction

    // Internal variables
    reg [3:0] SP_next;

    // Signals for operation
    wire can_push = EN && (RW == 1'b0) && !full;
    wire can_pop  = EN && (RW == 1'b1) && !empty;

    // Calculate the push address: SP_1hot shifted left by 1
    // but when SP_1hot is 1000 (empty), push address is index 3 (bit 3)
    // Actually, push addr = onehot_to_idx(SP_1hot) - 1
    // Because SP_1hot points to the next free slot, push writes to slot SP - 1
    // We can store index in integer for clarity

    integer push_addr, pop_addr;

    always @* begin
        push_addr = onehot_to_idx(SP_1hot) - 1;
        if (push_addr < 0)
            push_addr = 3;  // Wrap around for empty pointer '1000' -> index 3
        pop_addr = onehot_to_idx(SP_1hot);
    end

    always @(posedge Clk) begin
        if (Rst) begin
            SP_1hot <= 4'b1000; // Empty
            dataOut <= 4'd0;
            // Do NOT clear stack_mem to save reset time and area
        end else begin
            if (can_push) begin
                // Push operation: write to push_addr, shift pointer left
                stack_mem[push_addr] <= dataIn;
                // Shift pointer left (towards full)
                // 1000 -> 0100 -> 0010 -> 0001
                SP_1hot <= (SP_1hot << 1);
            end else if (can_pop) begin
                // Pop operation: read from pop_addr, shift pointer right
                dataOut <= stack_mem[pop_addr];
                // Shift pointer right (towards empty)
                // 0001 -> 0010 -> 0100 -> 1000
                SP_1hot <= (SP_1hot >> 1);
            end
            // else hold
        end
    end

endmodule