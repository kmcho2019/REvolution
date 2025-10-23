module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,        // Active high synchronous reset
    input  wire        EN,         // Enable for operations
    input  wire        RW,         // Read/Write control: 0 = push (write), 1 = pop (read)
    input  wire [3:0]  dataIn,     // Data input for push
    output wire        EMPTY,      // High when buffer is empty
    output wire        FULL,       // High when buffer is full
    output reg  [3:0]  dataOut     // Data output for pop
);

    // 4 entries of 4-bit wide stack memory
    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // Stack Pointer: points to next free slot
                   // SP=0 means empty, SP=4 means full

    // Control signals: enable push or pop only if buffer not full/empty and EN asserted
    wire push_en = EN && (RW == 1'b0) && (SP < 3'd4);
    wire pop_en  = EN && (RW == 1'b1) && (SP > 3'd0);

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset: clear stack_mem and set SP to empty (0)
            SP <= 3'd0;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else begin
            if (push_en) begin
                // Push: store dataIn at SP position, then increment SP
                stack_mem[SP] <= dataIn;
                SP <= SP + 3'd1;
            end else if (pop_en) begin
                // Pop: decrement SP, then output the popped data
                SP <= SP - 3'd1;
                dataOut <= stack_mem[SP - 3'd1];
                // No memory clearing for power saving
            end
            // No operation if EN=0 or invalid push/pop, hold state
        end
    end

    // Status flags: combinationally derived from SP
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule