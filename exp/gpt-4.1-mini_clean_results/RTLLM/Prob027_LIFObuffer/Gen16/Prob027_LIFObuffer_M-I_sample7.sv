module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,       // Active-high asynchronous reset
    input  wire        EN,        // Enable signal
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output wire        EMPTY,
    output wire        FULL
);

    // Stack memory: 4 entries, 4-bit each
    reg [3:0] stack_mem [3:0];

    // One-hot encoded Stack Pointer (SP):
    // SP[0] = empty stack
    // SP[1] to SP[4] point to stack levels
    reg [4:0] SP;

    // Initialization for asynchronous reset of stack memory registers
    integer i;
    // Async reset signals for stack memory bits (separately)
    // Synthesis tools typically support async reset on regs individually.

    // Functions to find index of '1' bit in SP (since only one bit is set)
    // For push: address = index(SP) - 1
    // For pop: address = index(SP)

    // This function returns 0-based index of the '1' bit in SP.
    function [2:0] sp_index;
        input [4:0] ptr;
        begin
            case(ptr)
                5'b00001: sp_index = 3'd0;
                5'b00010: sp_index = 3'd1;
                5'b00100: sp_index = 3'd2;
                5'b01000: sp_index = 3'd3;
                5'b10000: sp_index = 3'd4;
                default:  sp_index = 3'd0; // Safety default
            endcase
        end
    endfunction

    // Shift SP left for push, right for pop
    // Also check enable and full/empty conditions

    wire push_op = EN && (RW == 1'b0) && !FULL;
    wire pop_op  = EN && (RW == 1'b1) && !EMPTY;

    // Next SP calculation
    reg [4:0] next_SP;

    always @(*) begin
        if(push_op)
            next_SP = SP << 1;    // shift left for push
        else if(pop_op)
            next_SP = SP >> 1;    // shift right for pop
        else
            next_SP = SP;         // no change
    end

    // Determine addresses based on SP
    // On push: write to stack_mem at (sp_index(SP) - 1)
    // On pop: read from stack_mem at sp_index(SP)

    // push_addr and pop_addr need to be within 0..3
    wire [2:0] sp_idx = sp_index(SP);
    wire [2:0] push_addr = (sp_idx > 0) ? (sp_idx - 1) : 3'd0; // when sp_idx=0 empty, no push; safe default
    wire [2:0] pop_addr  = sp_idx;

    // Stack memory write enable
    wire mem_we = push_op;

    // Asynchronous reset for stack memory and SP and dataOut
    // Use async reset for SP and stack_mem separately
    // Rst is async active high

    // Asynchronous reset for SP and dataOut
    // SP reset to empty: 5'b00001 (bit0 set)
    always @(posedge Clk or posedge Rst) begin
        if (Rst) begin
            SP <= 5'b00001;
            dataOut <= 4'd0;
        end else begin
            SP <= next_SP;

            // dataOut updated only on pop_op
            if (pop_op) begin
                dataOut <= stack_mem[pop_addr];
            end
        end
    end

    // Async reset stack memory separately: synthesize as async reset flops
    genvar idx;
    generate
        for(idx=0; idx<4; idx=idx+1) begin : stack_mem_regs
            always @(posedge Clk or posedge Rst) begin
                if (Rst) begin
                    stack_mem[idx] <= 4'd0;
                end else if (mem_we && (push_addr == idx)) begin
                    stack_mem[idx] <= dataIn;
                end
                // No clearing on pop for power saving
            end
        end
    endgenerate

    // Flags combinational from SP one-hot bits
    assign EMPTY = SP[0];
    assign FULL  = SP[4];

endmodule