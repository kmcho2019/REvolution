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

    // One-hot Stack Pointer (SP)
    // 5 bits: SP[4] == 1 means empty; SP[0] == 1 means full
    reg [4:0] SP_onehot;

    // Find index of the current top of stack (for pop)
    // Index = position of bit set in SP_onehot, excluding empty bit 4
    // For push, next top is one less index; for pop, next top is one more index
    // Use encoding: positions 0..4 (SP_onehot[0] to SP_onehot[4])

    // EMPTY when SP_onehot == 5'b10000 (bit4 set)
    assign EMPTY = (SP_onehot == 5'b10000);
    // FULL when SP_onehot == 5'b00001 (bit0 set)
    assign FULL  = (SP_onehot == 5'b00001);

    // Convenience signals
    wire can_push = EN && (RW == 1'b0) && !FULL;
    wire can_pop  = EN && (RW == 1'b1) && !EMPTY;

    // Decode current pointer index (0 to 4)
    // position of '1' bit in SP_onehot
    function [2:0] get_sp_idx;
        input [4:0] sp;
        begin
            casex(sp)
                5'b00001: get_sp_idx = 3'd0;
                5'b00010: get_sp_idx = 3'd1;
                5'b00100: get_sp_idx = 3'd2;
                5'b01000: get_sp_idx = 3'd3;
                5'b10000: get_sp_idx = 3'd4;
                default:  get_sp_idx = 3'd4; // treat invalid as empty
            endcase
        end
    endfunction

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP_onehot <= 5'b10000;  // Empty pointer
            dataOut <= 4'd0;
            // stack_mem is not cleared to save area and reset time
        end else begin
            if (can_push) begin
                // Push operation:
                // current SP points to top+1 (empty slot)
                // decrement pointer by moving the '1' bit left
                // Example: from 10000(empty) to 01000 (index 3) after push to stack_mem[3]
                // write dataIn to new top index

                // Get current index (empty position)
                // Push: new top is one less index
                // So new pointer = SP_onehot shifted right by 1
                SP_onehot <= SP_onehot >> 1;
                // Write dataIn to new top index
                stack_mem[get_sp_idx(SP_onehot) - 1] <= dataIn; 
                // Using get_sp_idx(SP_onehot) -1 because we push one below empty position
                // get_sp_idx(SP_onehot) is in range 1..4 here
                // so subtract 1 to get stack_mem index 0..3
            end else if (can_pop) begin
                // Pop operation:
                // Current SP points to top of stack (lowest index)
                // Read dataOut from current top
                // Move pointer one up (shift left by 1)
                dataOut <= stack_mem[get_sp_idx(SP_onehot)];
                SP_onehot <= SP_onehot << 1;
                // We do not clear stack_mem to save switching power
            end
            // Else: no operation, hold states
        end
    end

endmodule