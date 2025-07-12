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

    // Stack memory: 4 entries of 4-bit data
    reg [3:0] stack_mem [3:0];

    // Stack pointer (SP): points to next free location (0..4)
    // SP = 4 means empty; SP = 0 means full
    reg [2:0] SP;

    // Internal register to hold popped data, pipelined one cycle
    reg [3:0] dataOut_next;

    integer i;

    // Push enabled if EN=1, RW=0 (write), and buffer not full
    wire push_en = EN && (RW == 1'b0) && (SP != 3'd0);
    // Pop enabled if EN=1, RW=1 (read), and buffer not empty
    wire pop_en  = EN && (RW == 1'b1) && (SP != 3'd4);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;            // Initialize stack pointer to empty
            dataOut <= 4'd0;
            dataOut_next <= 4'd0;
            // Clear stack memory
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else begin
            // Default: hold dataOut_next
            dataOut_next <= dataOut_next;

            if (push_en && !pop_en) begin
                // Push operation: decrement SP, then write dataIn at SP-1
                SP <= SP - 3'd1;
                stack_mem[SP - 3'd1] <= dataIn;
            end else if (pop_en && !push_en) begin
                // Pop operation: read data at SP, then increment SP
                dataOut_next <= stack_mem[SP];
                SP <= SP + 3'd1;
            end else if (push_en && pop_en) begin
                // Simultaneous push and pop:
                // No net SP change, overwrite the current top
                // Write dataIn at SP (no SP change)
                stack_mem[SP] <= dataIn;
                // DataOut updated to current top (which is overwritten)
                dataOut_next <= stack_mem[SP];
                // SP unchanged
            end else begin
                // No operation
                SP <= SP;
            end

            dataOut <= dataOut_next; // Pipeline output update to next cycle
        end
    end

    // Flags combinationally derived from SP
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule