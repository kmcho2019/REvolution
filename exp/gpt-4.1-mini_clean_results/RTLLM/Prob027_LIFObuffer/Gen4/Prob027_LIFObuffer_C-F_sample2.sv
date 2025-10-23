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

    // Stack Pointer: points to next free slot
    // 0 means empty, 4 means full
    reg [2:0] SP;

    integer i;

    // Synchronous SP update (separate block for pointer)
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;  // empty
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation - only if not full
                if (SP != 3'd4) begin
                    SP <= SP + 1;
                end
            end else begin
                // Pop operation - only if not empty
                if (SP != 3'd0) begin
                    SP <= SP - 1;
                end
            end
        end
    end

    // Synchronous memory and dataOut update
    always @(posedge Clk) begin
        if (Rst) begin
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation
                // SP points to next free slot before push,
                // so write at SP (old value), but SP increments in another block,
                // so index is SP before increment, so SP-1 after increment
                // To sync properly, write at SP (old value) which is SP-1 after increment
                // Since SP updates first block, SP here is old value before increment
                // So write at index = SP
                if (SP != 3'd4) begin
                    // Write dataIn to stack_mem[SP]
                    // But SP increments in other block, so here SP is old value
                    // Push writes at current SP index
                    stack_mem[SP] <= dataIn;
                end
            end else begin
                // Pop operation
                // After decrement of SP, pop reads from SP - 1 position,
                // but since SP updates separately, SP here is old value before decrement
                // So dataOut reads at SP - 1 index
                if (SP != 3'd0) begin
                    dataOut <= stack_mem[SP - 1];
                    // Do NOT clear memory on pop to reduce toggling
                end
            end
        end
    end

    // Flags derived combinationally from SP
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule