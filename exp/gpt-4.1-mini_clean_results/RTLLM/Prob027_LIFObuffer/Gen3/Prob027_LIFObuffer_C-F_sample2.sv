module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);
    // Stack memory: 4 entries of 4-bit width
    reg [3:0] stack_mem [3:0];

    // Stack pointer (SP): number of entries stored, range 0..4
    reg [2:0] SP;

    // Internal signals for push and pop enable
    wire push_en = EN & (~RW) & (SP < 4);
    wire pop_en  = EN & RW & (SP > 0);

    // Empty and full flags combinational from SP
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    // Temporary register to hold read data before output update
    reg [3:0] pop_data;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            pop_data <= 4'd0;
            // Do not clear stack_mem to reduce switching
        end else begin
            if (push_en) begin
                // Write data at current SP, then increment SP
                stack_mem[SP] <= dataIn;
                SP <= SP + 3'd1;
                // dataOut unchanged on push
            end else if (pop_en) begin
                // On pop, first decrement SP, then read data from stack_mem[SP - 1]
                // Since SP is still old value in this cycle, read now from SP-1 and register
                pop_data <= stack_mem[SP - 1];
                SP <= SP - 3'd1;
            end
            // Update dataOut with pop_data on next clock cycle
            // So dataOut is stable after pop operation completes
            if (pop_en) begin
                dataOut <= pop_data;
            end
        end
    end
endmodule